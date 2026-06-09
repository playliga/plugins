#include <sourcemod>
#include <sdktools>

public Plugin myinfo =
{
    name = "Timeout Plugin for LIGA",
    author = "zwayadev",
    description = "Timeouts for LIGA eSports Manager",
    version = "1.0b",
    url = "https://github.com/playliga"
};

#define TIMEOUT_DURATION 30
#define MAX_TIMEOUTS     3

bool g_bTimeoutActive = false;
bool g_bFreezeTime = false;

int g_iTimeoutsRemaining[4];
int g_iTimeRemaining;

Handle g_hTimeoutTimer = INVALID_HANDLE;

MoveType g_PreviousMoveType[MAXPLAYERS + 1];

public void OnPluginStart()
{
    RegConsoleCmd("sm_timeout", Command_Timeout);

    HookEvent("round_start", Event_RoundStart);
    HookEvent("round_freeze_end", Event_FreezeEnd, EventHookMode_PostNoCopy);

    ResetTimeouts();


}

public void OnClientPutInServer(int client)
{
    if (g_bTimeoutActive && IsPlayerAlive(client))
    {
        SetEntityMoveType(client, MOVETYPE_NONE);
        SetEntPropVector(client, Prop_Data, "m_vecVelocity", Float:{0.0, 0.0, 0.0});
    }
    PrintToChatAll("TO CALL A TIMEOUT TYPE .timeout CT/T");
}

public void OnMapStart()
{
    ResetTimeouts();
}

void ResetTimeouts()
{
    g_iTimeoutsRemaining[2] = MAX_TIMEOUTS; // T
    g_iTimeoutsRemaining[3] = MAX_TIMEOUTS; // CT
}

public Action Event_RoundStart(Event event, const char[] name, bool dontBroadcast)
{
    g_bFreezeTime = true;
    g_bTimeoutActive = false;

    return Plugin_Continue;
}

public Action Event_FreezeEnd(Event event, const char[] name, bool dontBroadcast)
{
    if (!g_bTimeoutActive)
    {
        g_bFreezeTime = false;
    }

    return Plugin_Continue;
}

void FreezeAllPlayers()
{
    for (int i = 1; i <= MaxClients; i++)
    {
        if (!IsClientInGame(i) || !IsPlayerAlive(i))
            continue;

        // stop movement instantly
        SetEntPropVector(i, Prop_Data, "m_vecVelocity", Float:{0.0, 0.0, 0.0});

        // disable movement
        SetEntityMoveType(i, MOVETYPE_NONE);
    }
}

void UnfreezeAllPlayers()
{
    for (int i = 1; i <= MaxClients; i++)
    {
        if (!IsClientInGame(i) || !IsPlayerAlive(i))
            continue;

        SetEntityMoveType(i, MOVETYPE_WALK);
    }
}

public Action Timer_Timeout(Handle timer)
{
    g_iTimeRemaining--;

    if (g_iTimeRemaining <= 0)
    {
        EndTimeout();
        return Plugin_Stop;
    }

    if (g_iTimeRemaining <= 5 || g_iTimeRemaining % 5 == 0)
    {
        PrintCenterTextAll(
            "TACTICAL TIMEOUT\n%d seconds remaining",
            g_iTimeRemaining
        );

        PrintToChatAll(
            "\x04[TIMEOUT]\x01 %d seconds remaining.",
            g_iTimeRemaining
        );
    }

    return Plugin_Continue;
}

void EndTimeout()
{
    UnfreezeAllPlayers();

    g_bTimeoutActive = false;
    g_bFreezeTime = false;

    g_hTimeoutTimer = INVALID_HANDLE;

    PrintToChatAll(
        "\x04[TIMEOUT]\x01 Timeout ended. Round live!"
    );

    PrintCenterTextAll("LIVE");
}

void StartTeamTimeout(int team, int client)
{
    if (g_bTimeoutActive)
    {
        PrintToChat(client, "[TIMEOUT] Already active.");
        return;
    }

    if (g_iTimeoutsRemaining[team] <= 0)
    {
        PrintToChat(client, "[TIMEOUT] No timeouts left for your team.");
        return;
    }

    g_iTimeoutsRemaining[team]--;
    g_bTimeoutActive = true;
    g_iTimeRemaining = 30;

    FreezeAllPlayers();

    if (team == 2)
        PrintToChatAll("[TIMEOUT] T called a timeout (%N), %d remaining timeouts for T", client, g_iTimeoutsRemaining[team]);
    else
        PrintToChatAll("[TIMEOUT] CT called a timeout (%N), %d remaining timeouts for T", client, g_iTimeoutsRemaining[team]);

    CreateTimer(1.0, Timer_Timeout, _, TIMER_REPEAT);
}

public Action OnClientSayCommand(int client, const char[] command, const char[] sArgs)
{
    if (StrContains(sArgs, ".timeout", false) != 0 &&
        StrContains(sArgs, "!timeout", false) != 0)
    {
        return Plugin_Continue;
    }

    char args[32];
    strcopy(args, sizeof(args), sArgs);

    ReplaceString(args, sizeof(args), ".timeout", "", false);
    ReplaceString(args, sizeof(args), "!timeout", "", false);

    TrimString(args);

    if (StrEqual(args, "CT", false))
    {
        StartTeamTimeout(3, client); // CT = team 3
        return Plugin_Handled;
    }

    if (StrEqual(args, "T", false))
    {
        StartTeamTimeout(2, client); // T = team 2
        return Plugin_Handled;
    }

    PrintToChat(client, "[TIMEOUT] Usage: .timeout CT or .timeout T");
    return Plugin_Handled;
}

public Action Command_Timeout(int client, int args)
{
    if (!IsClientInGame(client))
        return Plugin_Handled;

    int team = GetClientTeam(client);

    if (team != 2 && team != 3)
    {
        ReplyToCommand(client, "[Timeout] Join a team first.");
        return Plugin_Handled;
    }

    if (!g_bFreezeTime)
    {
        ReplyToCommand(client,
            "[Timeout] Timeouts may only be called during freeze time.");
        return Plugin_Handled;
    }

    if (g_bTimeoutActive)
    {
        ReplyToCommand(client,
            "[Timeout] A timeout is already active.");
        return Plugin_Handled;
    }

    if (g_iTimeoutsRemaining[team] <= 0)
    {
        ReplyToCommand(client,
            "[Timeout] Your team has no timeouts remaining.");
        return Plugin_Handled;
    }

    g_iTimeoutsRemaining[team]--;

    g_bTimeoutActive = true;
    g_iTimeRemaining = TIMEOUT_DURATION;

    FreezeAllPlayers();

    PrintToChatAll(
        "\x04[TIMEOUT]\x01 %N called a tactical timeout. %d remaining for this team.",
        client,
        g_iTimeoutsRemaining[team]
    );

    PrintToChatAll("DEBUG: timeout triggered");

    PrintCenterTextAll(
        "TACTICAL TIMEOUT\n30 seconds remaining"
    );

    g_hTimeoutTimer = CreateTimer(
        1.0,
        Timer_Timeout,
        _,
        TIMER_REPEAT
    );

    return Plugin_Handled;
}


