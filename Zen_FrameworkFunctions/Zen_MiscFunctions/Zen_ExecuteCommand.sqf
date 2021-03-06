// This file is part of Zenophon's ArmA 3 Co-op Mission Framework
// This file is released under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)
// See Legal.txt

_Zen_stack_Trace = ["Zen_ExecuteCommand", _this] call Zen_StackAdd;
private ["_cmd", "_args"];

if !([_this, [["STRING"], ["VOID"]], [], 2] call Zen_CheckArguments) exitWith {
    call Zen_StackRemove;
};

_cmd = _this select 0;
_args = _this select 1;

switch (toLower _cmd) do {
    case "action": {
        (_args select 0) action (_args select 1);
    };
    case "addaction": {
        (_args select 0) addAction (_args select 1);
    };
    case "allowdamage": {
        (_args select 0) allowDamage (_args select 1);
    };
    case "diag_log": {
        diag_log (_args select 0);
    };
    case "globalchat": {
        (_args select 0) globalChat (_args select 1);
    };
    case "groupchat": {
        (_args select 0) groupChat (_args select 1);
    };
    case "hint": {
        hint (_args select 0);
    };
    case "hintsilent": {
        hintSilent (_args select 0);
    };
    case "setvelocity": {
        (_args select 0) setVelocity (_args select 1);
    };
    case "setvariable": {
        (_args select 0) setVariable (_args select 1);
    };
    case "setvectorup": {
        (_args select 0) setVectorUp (_args select 1);
    };
    case "sidechat": {
        (_args select 0) sideChat (_args select 1);
    };
    case "switchmove": {
        (_args select 0) switchMove (_args select 1);
    };
    case "titletext": {
        titleText (_args select 0);
    };
    case "unassignvehicle": {
        unassignVehicle (_args select 0);
    };
    default {
        0 = ["Zen_ExecuteCommand", "Unsupported command sequence identifier given", _this] call Zen_PrintError;
        call Zen_StackPrint;
    };
};

call Zen_StackRemove;
if (true) exitWith {};
