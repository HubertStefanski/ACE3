//XEH_postInit.sqf
//#define DEBUG_MODE_FULL
#include "script_component.hpp"
"ACE_WIND_PARAMS" addPublicVariableEventHandler { GVAR(wind_period_start_time) = time; };
"ACE_RAIN_PARAMS" addPublicVariableEventHandler { GVAR(rain_period_start_time) = time; };

_fnc_uptadeWind = {
    _wind = ([] call FUNC(getWind));
    setWind [_wind select 0, _wind select 1, true];
    // _nWind = wind;
    // _pW = [_nWind select 0, _nWind select 1, 0] call CBA_fnc_vect2polar;
    // _pAW = [_wind select 0, _wind select 1, 0] call CBA_fnc_vect2polar;
    // hint format["w: %1 %2\na: %3 %4", _pW select 1, _pw select 0, _pAW select 1, _pAW select 0];
    // diag_log text format["ACE_WIND,%1,%2,%3,%4,%5", time, _pW select 1, _pw select 0, _pAW select 1, _pAW select 0];
};

[_fnc_uptadeWind, 1, []] call CBA_fnc_addPerFrameHandler;

_fnc_updateRain = {
    if(GVAR(enableRain)) then {
        if(!isNil "ACE_RAIN_PARAMS" && {!isNil QGVAR(rain_period_start_time)}) then {
            _oldStrength = ACE_RAIN_PARAMS select 0;
            _rainStrength = ACE_RAIN_PARAMS select 1;
            _transitionTime = ACE_RAIN_PARAMS select 2;
            _periodPosition = (time - GVAR(rain_period_start_time)) min _transitionTime;
            _periodPercent = (_periodPosition/_transitionTime) min 1;

            0 setRain ((_periodPercent*(_rainStrength-_oldStrength))+_oldStrength);
        };
    };
};

[_fnc_updateRain, 0, []] call CBA_fnc_addPerFrameHandler;