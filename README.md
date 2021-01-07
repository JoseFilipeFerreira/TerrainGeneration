# VI-2021

A project for Visualization and Lighting subject.

This project is dedicated to the generation of procedural 
terrains using the GPU and OpenGL Shader Language

## Running

```shell
nau_bin/composerImGui.exe ../nau_project/test.xml
```

## TODO

- [ ] Shaders that build terrain according to a sampler2D (perlin noise image)
- [ ] Perlin noise image generator script or executable

## Project Structure [WIP]

```
.
├── nau_bin/  # try to reduce the binaries (16Mb currently)
├── nau_project/
│   ├── assets/
│   │   ├── models/
│   │   │   └── teapot.3ds
│   │   └── noise/
│   │       ├── noise1.jpg
│   │       └── noise2.png
│   ├── shaders/
│   │   └── test/
│   │       ├── test.frag
│   │       └── test.vert
│   ├── test.mlib
│   └── test.xml
├── noise_terrain_script
├── README.md
└── LICENSE
```

> **Notes:** Since the xml loader only finds files of the project config
in the executable environment paths must be relative to it. That's the reason we include nau binaries. 
> 
> `nau_project` folder name mighty be changed to project object (like `terrain_gen` or something else)