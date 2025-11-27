<div align="center">
  <p>
    <a href="https://discord.gg/ZaEwHfDD5N"><img src="https://img.shields.io/discord/1296858234853789826?style=for-the-badge&label=Discord&logo=discord&logoColor=white" /></a>
    <a href="https://playliga.gg/#/#download"><img src="https://img.shields.io/badge/download-latest-salmon?style=for-the-badge&logo=github" /></a>
    <a href="https://github.com/playliga/prototype/milestones"><img src="https://img.shields.io/badge/view_the-roadmap-blue?style=for-the-badge&logo=rocket&logoColor=white" /></a>
  </p>
  <p>AMX Mod X and SourceMod Plugins for LIGA Esports Manager.</p>
  <p>Additional game configuration files and maps are also provided by this repository.</p>
</div>

# APIs and Technologies

- GoldSrc Engine
  - [AMX Mod X](https://www.amxmodx.org/) `v1.9.0` build `5294`
  - [Metamod](http://metamod.org/) `v1.21.1-am`
  - [ReGameDLL](https://github.com/rehlds/ReGameDLL_CS) `5.26.0.668`
- Source Engine
  - [SourceMod](https://www.sourcemod.net/) `v1.12.0`
  - [Metamod Source](https://www.sourcemm.net/) `v1.12.0`

# Prerequisites

1. Create a `generated` folder in the root of the project.
2. Download AMX Mod X and Metamod and extract their contents into the `generated` folder.

# Getting Started

> [!TIP]
> In VSCode, press `ctrl+shift+b` to automatically run the script below.

```bash
# build amxx and sourcemod plugins
generated/cstrike/addons/amxmodx/scripting/amxxpc.exe \
  -igenerated/cstrike/addons/amxmodx/scripting/include \
  -oconfig/cstrike/addons/amxmodx/plugins/liga.amxx \
  config/cstrike/addons/amxmodx/scripting/liga.sma
generated/csgo/addons/sourcemod/scripting/spcomp.exe \
  -igenerated/csgo/addons/sourcemod/scripting/include \
  -oconfig/csgo/addons/sourcemod/plugins/liga.smx \
  config/csgo/addons/sourcemod/scripting/liga.sp

# copy plugins to czero and css folders
cp config/cstrike/addons/amxmodx/plugins/liga.amxx config/czero/addons/amxmodx/plugins/liga.amxx
cp config/csgo/addons/sourcemod/plugins/liga.smx config/cssource/addons/sourcemod/plugins/liga.smx

#  copy to generated folder and stage to appdata
cp -r config/* generated/
cp -r generated/* "$APPDATA/LIGA Esports Manager/plugins/"
```

# VSCode Extension

Install the recommended workspace extension and configure the SourceMod extension paths.

```json
"SourcePawnLanguageServer.compiler.path": "<path_to_project>/generated/csgo/addons/sourcemod/scripting/spcomp.exe",
"SourcePawnLanguageServer.includeDirectories": ["<path_to_project>/generated/csgo/addons/sourcemod/scripting/include"],
"sourcepawn.outputDirectoryPath": "<path_to_project>/config/csgo/addons/sourcemod/plugins/",
```
