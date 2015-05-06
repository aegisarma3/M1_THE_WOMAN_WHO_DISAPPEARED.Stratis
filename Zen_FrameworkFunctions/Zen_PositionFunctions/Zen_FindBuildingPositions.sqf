// This file is part of Zenophon's ArmA 3 Co-op Mission Framework
// This file is released under Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)
// See Legal.txt

#include "Zen_StandardLibrary.sqf"

_Zen_stack_Trace = ["Zen_FindBuildingPositions", _this] call Zen_StackAdd;
private ["_building", "_allowRoof", "_Xdist", "_Ydist", "_points", "_positions", "_i", "_2dPos", "_floorPositions", "_j", "_3dPos", "_wallCount"];

if !([_this, [["VOID"], ["SCALAR"], ["BOOL"]], [], 1] call Zen_CheckArguments) exitWith {
    call Zen_StackRemove;
    ([[0,0,0]])
};

_building = nearestBuilding ([(_this select 0)] call Zen_ConvertToPosition);
_Xdist = ZEN_STD_OBJ_BBX(_building) / 2;
_Ydist = ZEN_STD_OBJ_BBY(_building) / 2;

ZEN_STD_Parse_GetArgumentDefault(_points, 1, (round (_Xdist * _Ydist / 2)) max 5)
ZEN_STD_Parse_GetArgumentDefault(_allowRoof, 2, false)
_positions = [];

for "_i" from 1 to _points do {
    _2dPos = [(getPosATL _building), [_Xdist, _Ydist], 90 - (getDir _building), "rectangle", [random 360]] call Zen_FindPositionPoly;
    _2dPos set [2, getTerrainHeightASL _2dPos];
    _floorPositions = [];

    for "_j" from 1 to 20 do {
        if !(lineIntersects [_2dPos, ZEN_STD_Math_TransformATL(_2dPos, 0, 0, 0.2), objNull, objNull]) exitWith {};
        _2dPos = ZEN_STD_Math_TransformATL(_2dPos, 0, 0, 0.2);
    };

    if (_allowRoof || (lineIntersects [ZEN_STD_Math_TransformATL(_2dPos, 0, 0, 0.1), ZEN_STD_Math_TransformATL(_2dPos, 0, 0, 50), objNull, objNull])) then {
        _3dPos =+ _2dPos;
        for "_j" from 1 to 50 do {
            if ((lineIntersects [_3dPos, ZEN_STD_Math_TransformATL(_3dPos, 0, 0, -0.25), objNull, objNull]) && {!(lineIntersects [_3dPos, ZEN_STD_Math_TransformATL(_3dPos, 0, 0, 1.6), objNull, objNull])}) then {
                if (_allowRoof) then {
                    _floorPositions pushBack _3dPos;
                } else {
                    if !(lineIntersects [ZEN_STD_Math_TransformATL(_3dPos, 0, 0, 0.5), ZEN_STD_Math_TransformATL(_3dPos, 0, 0, 50), objNull, objNull]) then {
                        _wallCount = 0;
                        for "_k" from 0 to 330 step 30 do {
                            if (lineIntersects [ZEN_STD_Math_TransformATL(_3dPos, 0, 0, 0.1), ZEN_STD_Math_TransformATL(_3dPos, 10 * cos _k, 10 * sin _k, 0.1), objNull, objNull]) then {
                                _wallCount = _wallCount + 1;
                            };
                        };

                        if (_wallCount > 12) then {
                            _floorPositions pushBack _3dPos;
                        };
                    } else {
                        _floorPositions pushBack _3dPos;
                    };
                };
            };

            _3dPos = ZEN_STD_Math_TransformATL(_3dPos, 0, 0, 0.25);
        };
    };

    0 = [_positions, _floorPositions] call Zen_ArrayAppendNested;
};

{
    _3dPos =+ _x;
    for "_i" from 1 to 20 do {
        if (lineIntersects [_3dPos, ZEN_STD_Math_TransformATL(_3dPos, 0, 0, -0.02), objNull, objNull]) exitWith {};
        _3dPos = ZEN_STD_Math_TransformATL(_3dPos, 0, 0, -0.02);
    };
    _positions set [_forEachIndex, ASLToATL _3dPos];
} forEach _positions;

call Zen_StackRemove;
(_positions)
