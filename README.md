# LIGA Esports Manager Plugins

[![Discord](https://img.shields.io/discord/1296858234853789826?style=for-the-badge&label=Join%20the%20Discord%20Server&link=https%3A%2F%2Fdiscord.gg%2FZaEwHfDD5N)](https://discord.gg/ZaEwHfDD5N)

AMX Mod X and SourceMod Plugins for LIGA Esports Manager.

Additional game configuration files and maps are also provided by this repository.

## APIs and Technologies

- Node `v20.9.x`
- GoldSrc Engine
  - [AMX Mod X](https://www.amxmodx.org/) `v1.8.2`
  - [Metamod](http://metamod.org/) `v1.21.1-am`
  - [ReGameDLL](https://github.com/rehlds/ReGameDLL_CS) `5.26.0.668`
- Source Engine
  - [SourceMod](https://www.sourcemod.net/) `v1.11.0`
  - [Metamod Source](https://www.sourcemm.net/) `v1.11.0`
  - [CSGOBetterBots](https://github.com/manicogaming/CSGOBetterBots)

## Getting Started

```bash
npm install
npx tsx cli/compiler.mts
```

## VSCode Extension

Install the recommended workspace extension and configure the SourceMod extension paths.

```json
"SourcePawnLanguageServer.compiler.path": "<path_to_project>/generated/csgo/addons/sourcemod/scripting/spcomp.exe",
"SourcePawnLanguageServer.includeDirectories": ["<path_to_project>/generated/csgo/addons/sourcemod/scripting/include"],
"sourcepawn.outputDirectoryPath": "<path_to_project>/config/csgo/addons/sourcemod/plugins/",
```
