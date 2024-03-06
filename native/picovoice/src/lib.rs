use porcupine::{PorcupineBuilder, Porcupine};
use pv_recorder::{PvRecorderBuilder, PvRecorder};
use cobra::Cobra;

use rand::distributions::{Alphanumeric, DistString};

fn start_voice_activity_detection(access_key: &str) -> Cobra {
    Cobra::new(access_key).expect("Cannot create cobra")
}

fn start_recorder(frame_length: i32) -> PvRecorder {
    let recorder = PvRecorderBuilder::new(frame_length)
        .device_index(2)
        .init()
        .expect("Failed to initialize pvrecorder");

    recorder.start().expect("Failed to start audio recording");
    recorder
}

fn start_wake_word_detector(access_key: &str, keyword_path: &str, model_path: &str) -> Porcupine {
    PorcupineBuilder::new_with_keyword_paths(
        access_key, 
        &[keyword_path],
    )
    .model_path(model_path)
    .sensitivities(&[0.5])
    .init()
    .expect("Unable to create Porcupine")
}


fn said_the_wake_word(detector: &Porcupine, frame: &Vec<i16>) -> bool {
    detector.process(&frame).unwrap() >= 0
}

#[derive(PartialEq, Debug)]
enum State {
    WaitingWakeWord,
    WakeWordDetected,
    AudioRecording,
    Done,
    Failed
}

#[rustler::nif(schedule="DirtyIo")]
fn query(access_key: &str, keyword_path: &str, model_path: &str) -> String {
    let voice_detector = start_voice_activity_detection(access_key);
    let detector = start_wake_word_detector(access_key, keyword_path, model_path);
    let recorder = start_recorder(detector.frame_length() as i32);

    let mut counter = 0;
    let mut _voice_prob: f32;
    let mut state = State::WaitingWakeWord;
    let mut audio = Vec::new();

    loop {
        if !recorder.is_recording() {
            _ = State::Failed;
            break;
        }

        let frame = recorder.read().expect("Failed to read audio frame");

        (state, counter) = match (state, counter) {
            (State::WaitingWakeWord, _) =>
                if said_the_wake_word(&detector, &frame) {
                    (State::WakeWordDetected, 0)
                } else {
                    (State::WaitingWakeWord, 0)
                },
            (State::WakeWordDetected, 0) => (State::AudioRecording, 0),
            (State::AudioRecording, 200) => (State::Done, 0),
            (State::AudioRecording, counter) => (State::AudioRecording, counter + 1),
            _ => (State::Done, 0)
        };

        _voice_prob = voice_detector.process(&frame).expect("Cannot read frame");

        if state == State::WakeWordDetected {
            println!("\r[{}] {:?}", counter, state);
            audio.extend_from_slice(&frame);
        }

        if state == State::AudioRecording {
            audio.extend_from_slice(&frame);
        }

        if state == State::Done {
            break;
        }
    }

    recorder.stop().expect("Failed to stop audio recording");

    let random = Alphanumeric.sample_string(&mut rand::thread_rng(), 16);
    let path = format!("{}.wav", random);

    let mut writer = hound::WavWriter::create(path.clone(), hound::WavSpec {
        channels: 1,
        sample_rate: detector.sample_rate(),
        bits_per_sample: 16,
        sample_format: hound::SampleFormat::Int,
    }).expect("Failed to open output audio file");
    for sample in audio {
        writer.write_sample(sample).unwrap();
    }

    writer.finalize().expect("Cannot finalize WAV write operations");

    return String::from(path);
}

rustler::init!("Elixir.Assistant.Models.Audio.WakeWord", [query]);
