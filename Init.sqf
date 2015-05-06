#include "Zen_FrameworkFunctions\Zen_InitHeader.sqf"

// <The Woman Who Disappeared> by <Cap Collumbus [BTS]>
// Version = <0.1>ddddd
// Tested with ArmA 3 <1.28>

// This will fade in from black, to hide jarring actions at mission start, this is optional and you can change the value
titleText ["A morte é certa, a vida não.", "BLACK FADED", 0.25];


// SQF functions cannot continue running after loading a saved game, do not delete this line
enableSaving [false, false];

// Cria o briefing

player creatediaryRecord["Diary", ["Execução", "A operação terá inicio às 4:15 com inserção da equipe Miller pela praia de Jay Cove (marcação Urso-01), Uma segunda inserção sera realizada pela equipe Kaizer próximo a praia de Tsoukala (marcação Urso-02). As equipes devem ser muito cautelosas com seu avanço pois a ilha é dominada por traficantes a alguns anos, contudo Tyler deve ser resgatada antes que os traficantes a encontre.<br/>O namorado da Biologa, que também estava a bordo da aeronave realizou um último contato a 4 dias atràs informando que foi realizado um pouso forçado próximo das coordenadas 031033."]];

player creatediaryRecord["Diary", ["Situação", "A bióloga Tyler Fox filha do magnata do petróleo Simon Fox, saiu em uma expedição de pesquisa com destino a ilha de Irmali.<br/>Ainda em transito a areonave Black Squirrel-06 (modelo AW101-Merlin) aprensentou falhas elétricas, perdendo contato com a torre logo em seguida.<br/>O último contato da aeronave ocorreu a 5 dias atrás próximo a ilha de Stratis. A empresa AEGIS foi contactada diretamente por Simon, solicitando urgência na busca de sua filha e temendo que ela seja sequestrada pelos traficantes locais. Após o contato de Simon uma varredura realizada pelo satélite AEGIS-ORION-12 sobre a ilha de Stratis captou a imagem abaixo com a possível aeronave.<br/><br/><img image='signs\heli1.jpg' width='430' height='430'/><br/><br/> <br/>Abaixo se encontra as caracteristicas e uma foto recente, enviada por celular pela própria bióloga a três atràs. <br/><br/><img image='signs\wom.jpg' width='430' height='294'/><br/><br/>Nome: Tyler Fox<br/>Nacionalidade: Britânica<br/>Idade: 34<br/>Altura: 174 cm<br/>Peso: 62 Kg<br/>Cor dos cabelos: Castanho escuro<br/>Cor dos olhos: Castanhos<br/><br/>"]];

player creatediaryRecord["Diary", ["Missão", "A missão dos grupamentos Miller e Kaiser é encontrar e resgatar a bióloga Tyler Fox desaparecida a 5 dias após a suposta queda do helicoptero particular de seu pai.<br/><br/>"]];

execVM "Intro.sqf";

// Desabilita o lixo do thermal image
0 = [] spawn {

    _layer = 85125; 
    while {true} do 
    { 
        if (currentVisionMode player == 2) then
            { 
                //hint "Porcaria de thermal";
                _layer  cutText ["ERR 0921F - No battery or insufficient memory","BLACK",-3];
                waituntil {currentVisionMode player != 2};
                _layer cutText ["", "PLAIN"];
            };
            sleep 0.5; 
    };
};

    

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////// CLIENT SIDE PARA NESTA LINHA  /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////


if (!isServer) exitWith {};
// Execution stops until the mission begins (past briefing), do not delete this line
sleep 1.5;

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////// SERVER SIDE A PARTIR DESTA LINHA  /////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// Apaga os maracdores do mapa
#define _MARKERALPHA(ARG1) ARG1 setMarkerAlpha 0;
_MARKERALPHA("patrol_area_01");
_MARKERALPHA("patrol_area_02");
_MARKERALPHA("patrol_area_03");
_MARKERALPHA("patrol_area_04");
_MARKERALPHA("patrol_area_05");
_MARKERALPHA("patrol_area_06");
_MARKERALPHA("patrol_area_07");
_MARKERALPHA("patrol_area_08");
_MARKERALPHA("CIV1");
_MARKERALPHA("LZ1");
_MARKERALPHA("int_pint_04");
_MARKERALPHA("vehicle_patrol_area_01");
_MARKERALPHA("vehicle_patrol_area_02");
_MARKERALPHA("v");
_MARKERALPHA("v_1");
_MARKERALPHA("v_2");
_MARKERALPHA("v_3");
_MARKERALPHA("v_1");
_MARKERALPHA("Field_01");
_MARKERALPHA("Field_02");
_MARKERALPHA("Field_03");
_MARKERALPHA("Field_04");
_MARKERALPHA("Field_05");
_MARKERALPHA("Field_06");
_MARKERALPHA("Field_07");
_MARKERALPHA("Field_08");
_MARKERALPHA("Field_09");
_MARKERALPHA("Field_10");
_MARKERALPHA("Field_11");
_MARKERALPHA("Field_12");

// Cacheia os grupos para performance
Miller = group p1;
Kaiser = group p1_1;



//Carrega objetos do editor 3d
if (isServer) then {call compile preprocessFile "Editor3d\initBuildings.sqf";};

//Spawn do helicoptero de inspeção
helicopter   = ["heliSpawnPos", "PMC_MH9", 4] call Zen_SpawnHelicopter;
helicopter_1 = ["heliSpawnPos_1", "PMC_MH9", 4] call Zen_SpawnHelicopter;

//alocação dos players no helicoptero de inserção
0 = [Miller, helicopter] call Zen_MoveInVehicle;
0 = [Kaiser, helicopter_1] call Zen_MoveInVehicle;

//Envia helicoptero de inserção para zona de pouso
0 = [helicopter, ["helipad_1","helipad_2"], Miller, "normal", 10] spawn Zen_OrderInsertion;
0 = [helicopter_1, ["helipad_3","helipad_4"], Kaiser, "normal", 10] spawn Zen_OrderInsertion;

Chem attachTo [helicopter,[0.5,1,-1]];
Chem1 attachTo [helicopter_1,[0.5,1,-1]];

////////////////////////////////////////////////////////////////////////////////////
//=/=/=/=/=/=/=/=/=/=/=/=/=/ PATRULHAS ALEATORIOS //=/=/=/=/=/=/=/=/=/=/=/=/=/
//////////////////////////////////////////////////////////////////////////////////

//Patrulha-01
_PatrolPosition_01 = ["patrol_area_01"] call
Zen_FindGroundPosition;
_PatrolGuard_01 = [_PatrolPosition_01, east, "Infantry", [2,3], "MEN", "caf_ag_eeur_r"] call Zen_SpawnInfantry;
0 = [_PatrolGuard_01, "patrol_area_01"] spawn
Zen_OrderInfantryPatrol;

//Patrulha-02
_PatrolPosition_02 = ["patrol_area_02"] call
Zen_FindGroundPosition;
_PatrolGuard_02 = [_PatrolPosition_02, east, "Infantry", [3,4], "MEN", "caf_ag_eeur_r"] call Zen_SpawnInfantry;
0 = [_PatrolGuard_02, "patrol_area_02"] spawn
Zen_OrderInfantryPatrol;

//Patrulha-03
_PatrolPosition_03 = ["patrol_area_03"] call
Zen_FindGroundPosition;
_PatrolGuard_03 = [_PatrolPosition_03, east, "Infantry", [3,5], "MEN", "caf_ag_eeur_r"] call Zen_SpawnInfantry;
0 = [_PatrolGuard_03, "patrol_area_03"] spawn
Zen_OrderInfantryPatrol;

//Patrulha-04
_PatrolPosition_04 = ["patrol_area_04"] call
Zen_FindGroundPosition;
_PatrolGuard_04 = [_PatrolPosition_04, east, "Infantry", [3,6], "MEN", "caf_ag_eeur_r"] call Zen_SpawnInfantry;
0 = [_PatrolGuard_04, "patrol_area_04"] spawn
Zen_OrderInfantryPatrol;

//Patrulha-05
_PatrolPosition_05 = ["patrol_area_05"] call
Zen_FindGroundPosition;
_PatrolGuard_05 = [_PatrolPosition_05, east, "Infantry", [4,6], "MEN", "caf_ag_eeur_r"] call Zen_SpawnInfantry;
0 = [_PatrolGuard_05, "patrol_area_05"] spawn
Zen_OrderInfantryPatrol;

//Patrulha-06
_PatrolPosition_06 = ["patrol_area_06"] call
Zen_FindGroundPosition;
_PatrolGuard_06 = [_PatrolPosition_06, east, "Infantry", [5,10], "MEN", "caf_ag_eeur_r"] call Zen_SpawnInfantry;
0 = [_PatrolGuard_06, "patrol_area_06"] spawn
Zen_OrderInfantryPatrol;

//Patrulha-07
_PatrolPosition_07 = ["patrol_area_07"] call
Zen_FindGroundPosition;
_PatrolGuard_07 = [_PatrolPosition_07, east, "Infantry", [4,7], "MEN", "caf_ag_eeur_r"] call Zen_SpawnInfantry;
0 = [_PatrolGuard_07, "patrol_area_07"] spawn
Zen_OrderInfantryPatrol;

//Patrulha-08
_PatrolPosition_08 = ["patrol_area_04"] call
Zen_FindGroundPosition;
_PatrolGuard_08 = [_PatrolPosition_08, east, "Infantry", [2,3], "MEN", "caf_ag_eeur_r"] call Zen_SpawnInfantry;
0 = [_PatrolGuard_08, "patrol_area_04"] spawn
Zen_OrderInfantryPatrol;

//Patrulha-09
_PatrolPosition_09 = ["patrol_area_07"] call
Zen_FindGroundPosition;
_PatrolGuard_09 = [_PatrolPosition_09, east, "Infantry", [1,3], "MEN", "caf_ag_eeur_r"] call Zen_SpawnInfantry;
0 = [_PatrolGuard_09, "patrol_area_07"] spawn
Zen_OrderInfantryPatrol;

//Patrulha-10
_PatrolPosition_10 = ["patrol_area_07"] call
Zen_FindGroundPosition;
_PatrolGuard_10 = [_PatrolPosition_10, east, "Infantry", [1,2], "MEN", "caf_ag_eeur_r"] call Zen_SpawnInfantry;
0 = [_PatrolGuard_10, "patrol_area_07"] spawn
Zen_OrderInfantryPatrol;

//Patrulha-11
_PatrolPosition_11 = ["patrol_area_06"] call
Zen_FindGroundPosition;
_PatrolGuard_11 = [_PatrolPosition_11, east, "Infantry", [2,4], "MEN", "caf_ag_eeur_r"] call Zen_SpawnInfantry;
0 = [_PatrolGuard_11, "patrol_area_06"] spawn
Zen_OrderInfantryPatrol;

//Patrulha-12
_PatrolPosition_12 = ["patrol_area_06"] call
Zen_FindGroundPosition;
_PatrolGuard_12 = [_PatrolPosition_12, east, "Infantry", [2,3], "MEN", "caf_ag_eeur_r"] call Zen_SpawnInfantry;
0 = [_PatrolGuard_12, "patrol_area_06"] spawn
Zen_OrderInfantryPatrol;

//terror_area_02

//Patrulha-13
_PatrolPosition_13 = ["terror_area_02"] call
Zen_FindGroundPosition;
_PatrolGuard_13 = [_PatrolPosition_13, east, "Infantry", [2,3], "MEN", "caf_ag_eeur_r"] call Zen_SpawnInfantry;
0 = [_PatrolGuard_13, "terror_area_02"] spawn
Zen_OrderInfantryPatrol;

//Patrulha-14
_PatrolPosition_14 = ["terror_area_02"] call
Zen_FindGroundPosition;
_PatrolGuard_14 = [_PatrolPosition_14, east, "Infantry", [2,3], "MEN", "caf_ag_eeur_r"] call Zen_SpawnInfantry;
0 = [_PatrolGuard_14, "terror_area_02"] spawn
Zen_OrderInfantryPatrol;

//Patrulha-15
_PatrolPosition_15 = ["terror_area_01"] call
Zen_FindGroundPosition;
_PatrolGuard_15 = [_PatrolPosition_15, east, "Infantry", [2,3], "MEN", "caf_ag_eeur_r"] call Zen_SpawnInfantry;
0 = [_PatrolGuard_15, "terror_area_01"] spawn
Zen_OrderInfantryPatrol;

//Patrulha-16
_PatrolPosition_16 = ["terror_area_01"] call
Zen_FindGroundPosition;
_PatrolGuard_16 = [_PatrolPosition_16, east, "Infantry", [2,3], "MEN", "caf_ag_eeur_r"] call Zen_SpawnInfantry;
0 = [_PatrolGuard_16, "terror_area_01"] spawn
Zen_OrderInfantryPatrol;

//Patrulha-17
_PatrolPosition_17 = ["patrol_area_08"] call
Zen_FindGroundPosition;
_PatrolGuard_17 = [_PatrolPosition_17, east, "Infantry", [2,3], "MEN", "caf_ag_eeur_r"] call Zen_SpawnInfantry;
0 = [_PatrolGuard_17, "patrol_area_08"] spawn
Zen_OrderInfantryPatrol;

//Patrulha-18
_PatrolPosition_18 = ["patrol_area_08"] call
Zen_FindGroundPosition;
_PatrolGuard_18 = [_PatrolPosition_18, east, "Infantry", [2,3], "MEN", "caf_ag_eeur_r"] call Zen_SpawnInfantry;
0 = [_PatrolGuard_18, "patrol_area_08"] spawn
Zen_OrderInfantryPatrol;

//Patrulha-19
_PatrolPosition_19 = ["patrol_area_08"] call
Zen_FindGroundPosition;
_PatrolGuard_19 = [_PatrolPosition_19, east, "Infantry", [2,3], "MEN", "caf_ag_eeur_r"] call Zen_SpawnInfantry;
0 = [_PatrolGuard_19, "patrol_area_08"] spawn
Zen_OrderInfantryPatrol;

//Patrulha-20
_PatrolPosition_20 = ["int_pint_04"] call
Zen_FindGroundPosition;
_PatrolGuard_20 = [_PatrolPosition_20, east, "Infantry", [4,6], "MEN", "caf_ag_eeur_r"] call Zen_SpawnInfantry;
0 = [_PatrolGuard_20, "int_pint_04"] spawn
Zen_OrderInfantryPatrol;

////////////////////////////////////////////////////////////////////////////////////
//=/=/=/=/=/=/=/=/=/=/=/=/=/ PATRULHAS VEICULAR=/=/=/=/=/=/=/
//////////////////////////////////////////////////////////////////////////////////



//Patrulha Veicular-01
v_patrol_01 = ["vpatrol_01", ["CAF_AG_eeur_r_Offroad_armed_01"], 55, "caf_ag_eeur_r"] call Zen_SpawnGroundVehicle; 
0 = [v_patrol_01, "vehicle_patrol_area_01"] spawn Zen_OrderVehiclePatrol;

//Patrulha Veicular-02
v_patrol_02 = ["vpatrol_02", ["CAF_AG_eeur_r_Offroad_armed_01"], 55, "caf_ag_eeur_r"] call Zen_SpawnGroundVehicle; 
0 = [v_patrol_02, "vehicle_patrol_area_01"] spawn Zen_OrderVehiclePatrol;

//Patrulha Veicular-03
v_patrol_03 = ["vpatrol_03", ["CAF_AG_eeur_r_Offroad_armed_01"], 55, "caf_ag_eeur_r"] call Zen_SpawnGroundVehicle; 
0 = [v_patrol_03, "vehicle_patrol_area_01"] spawn Zen_OrderVehiclePatrol;

//Patrulha Veicular-04
v_patrol_04 = ["vpatrol_04", ["CAF_AG_eeur_r_Offroad_armed_01"], 55, "caf_ag_eeur_r"] call Zen_SpawnGroundVehicle; 
0 = [v_patrol_04, "vehicle_patrol_area_02"] spawn Zen_OrderVehiclePatrol;

//Patrulha Veicular-05
v_patrol_05 = ["vpatrol_05", ["CAF_AG_eeur_r_Offroad_armed_01"], 55, "caf_ag_eeur_r"] call Zen_SpawnGroundVehicle; 
0 = [v_patrol_05, "vehicle_patrol_area_02"] spawn Zen_OrderVehiclePatrol;

//Patrulha Veicular-06
v_patrol_06 = ["vpatrol_06", ["CAF_AG_eeur_r_Offroad_armed_01"], 55, "caf_ag_eeur_r"] call Zen_SpawnGroundVehicle; 
0 = [v_patrol_06, "vehicle_patrol_area_02"] spawn Zen_OrderVehiclePatrol;

////////////////////////////////////////////////////////////////////////////////////
//=/=/=/=/=/=/=/=/=/=/=/=/=/ Guarda Guaritas=/=/=/=/=/=/=/
//////////////////////////////////////////////////////////////////////////////////

_v01 = [ "v", east, "Infantry", 1, "MEN", "caf_ag_eeur_r"] call Zen_SpawnInfantry;
_v02 = [ "v_1", east, "Infantry", 1, "MEN", "caf_ag_eeur_r"] call Zen_SpawnInfantry;
_v03 = [ "v_2", east, "Infantry", 1, "MEN", "caf_ag_eeur_r"] call Zen_SpawnInfantry;
_v04 = [ "v_3", east, "Infantry", 1, "MEN", "caf_ag_eeur_r"] call Zen_SpawnInfantry;


////////////////////////////////////////////////////////////////////////////////////
//=/=/=/=/=/=/=/=/=/=/=/=/=/ Guarda Pontos de Interesse=/=/=/=/=/=/=/
//////////////////////////////////////////////////////////////////////////////////

_OcupPosition_01= ["Field_01"] call Zen_FindGroundPosition;
_OcupGuard_01 = [_OcupPosition_01, east, "Infantry", 1, "MEN", "caf_ag_eeur_r"] call Zen_SpawnInfantryGarrison;
_OcupGuard_01 = [_OcupPosition_01, east, "Infantry", 1, "MEN", "caf_ag_eeur_r"] call Zen_SpawnInfantryGarrison;

_OcupPosition_02= ["Field_02"] call Zen_FindGroundPosition;
_OcupGuard_02 = [_OcupPosition_02, east, "Infantry", 1, "MEN", "caf_ag_eeur_r"] call Zen_SpawnInfantryGarrison;
_OcupGuard_02 = [_OcupPosition_02, east, "Infantry", 1, "MEN", "caf_ag_eeur_r"] call Zen_SpawnInfantryGarrison;

_OcupPosition_03= ["Field_03"] call Zen_FindGroundPosition;
_OcupGuard_03 = [_OcupPosition_03, east, "Infantry", 1, "MEN", "caf_ag_eeur_r"] call Zen_SpawnInfantryGarrison;
_OcupGuard_03 = [_OcupPosition_03, east, "Infantry", 1, "MEN", "caf_ag_eeur_r"] call Zen_SpawnInfantryGarrison;

_OcupPosition_04= ["Field_04"] call Zen_FindGroundPosition;
_OcupGuard_04 = [_OcupPosition_04, east, "Infantry", 1, "MEN", "caf_ag_eeur_r"] call Zen_SpawnInfantryGarrison;
_OcupGuard_04 = [_OcupPosition_04, east, "Infantry", 1, "MEN", "caf_ag_eeur_r"] call Zen_SpawnInfantryGarrison;

_OcupPosition_05= ["Field_05"] call Zen_FindGroundPosition;
_OcupGuard_05 = [_OcupPosition_05, east, "Infantry", 1, "MEN", "caf_ag_eeur_r"] call Zen_SpawnInfantryGarrison;
_OcupGuard_05 = [_OcupPosition_05, east, "Infantry", 1, "MEN", "caf_ag_eeur_r"] call Zen_SpawnInfantryGarrison;

_OcupPosition_06= ["Field_06"] call Zen_FindGroundPosition;
_OcupGuard_06= [_OcupPosition_06, east, "Infantry", 1, "MEN", "caf_ag_eeur_r"] call Zen_SpawnInfantryGarrison;
_OcupGuard_06= [_OcupPosition_06, east, "Infantry", 1, "MEN", "caf_ag_eeur_r"] call Zen_SpawnInfantryGarrison;

_OcupPosition_07= ["Field_07"] call Zen_FindGroundPosition;
_OcupGuard_07 = [_OcupPosition_07, east, "Infantry", 1, "MEN", "caf_ag_eeur_r"] call Zen_SpawnInfantryGarrison;
_OcupGuard_07 = [_OcupPosition_07, east, "Infantry", 1, "MEN", "caf_ag_eeur_r"] call Zen_SpawnInfantryGarrison;

_OcupPosition_08= ["int_pint_04"] call Zen_FindGroundPosition;
_OcupGuard_08 = [_OcupPosition_08, east, "Infantry", [3,5], "MEN", "caf_ag_eeur_r"] call Zen_SpawnInfantry;
0 = [_OcupGuard_08, "int_pint_04"] spawn
Zen_OrderInfantryPatrol;

_OcupPosition_09= ["Field_08"] call Zen_FindGroundPosition;
_OcupGuard_09 = [_OcupPosition_09, east, "Infantry", [4,5], "MEN", "caf_ag_eeur_r"] call Zen_SpawnInfantry;
0 = [_OcupGuard_09, "Field_08"] spawn
Zen_OrderInfantryPatrol;

_OcupGuard_10 = [_OcupPosition_09, east, "Infantry", [4,5], "MEN", "caf_ag_eeur_r"] call Zen_SpawnInfantry;
0 = [_OcupGuard_10, "Field_08"] spawn
Zen_OrderInfantryPatrol;

_OcupGuard_11 = [_OcupPosition_09, east, "Infantry", [4,5], "MEN", "caf_ag_eeur_r"] call Zen_SpawnInfantry;
0 = [_OcupGuard_11, "Field_08"] spawn
Zen_OrderInfantryPatrol;

_OcupPosition_12= ["Field_09"] call Zen_FindGroundPosition;
_OcupGuard_12 = [_OcupPosition_12, east, "Infantry", [3,5], "MEN", "caf_ag_eeur_r"] call Zen_SpawnInfantry;


_OcupPosition_13= ["Field_10"] call Zen_FindGroundPosition;
_OcupGuard_13 = [_OcupPosition_13, east, "Infantry", [3,5], "MEN", "caf_ag_eeur_r"] call Zen_SpawnInfantry;

_OcupPosition_13= ["Field_11"] call Zen_FindGroundPosition;
_OcupGuard_13 = [_OcupPosition_13, east, "Infantry", [3,5], "MEN", "caf_ag_eeur_r"] call Zen_SpawnInfantry;

_OcupPosition_14= ["Field_12"] call Zen_FindGroundPosition;
_OcupGuard_14 = [_OcupPosition_14, east, "Infantry", [3,5], "MEN", "caf_ag_eeur_r"] call Zen_SpawnInfantry;
sleep 120;





