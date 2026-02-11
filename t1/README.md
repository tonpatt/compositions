# t1

**t1** is an algorithmic music experiment. The sound structure is defined in Csound, while the score was externally generated using Python/C++ algorithms.

## Project Notes

To ensure portability and avoid complex dependency issues (Python/pybind11), the `score.sco` file is pre-rendered and included in this repository. You do not need to run the original generation scripts to compile the audio.

## Audio Generation

This project uses a `Makefile` to automate the rendering process. To successfully build the audio files, ensure the following components are in the same directory:

* **Main files**: `cat1.csd` and `score.sco`
* **Orchestra & UDOs**: `instrs.orc` and `generators.udo`

### Commands

* **To create the FLAC file:**

```bash
make flac

```

* **To create the OGG file:**

```bash
make ogg

```

## Requirements

* **Csound 6.18** or higher
* **GNU Make**

## Listen

You can listen to the composition on [SoundCloud](https://soundcloud.com/gianantonio-patella/t1x?si=a47885e971f4465bb9311f7fbb8284e7&utm_source=clipboard&utm_medium=text&utm_campaign=social_sharing).

## License

This project is licensed under a **Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License (CC BY-NC-SA 4.0)**.
