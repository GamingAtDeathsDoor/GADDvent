/** 
	GADDvent Calendar by [GADD]Monkeynutz
**/

_uid = getPlayerUID player; 
_dayOfXmas = systemTime select 2;
_pinRandom = (1000 +(round (random 8999)));
_pin = format ["%1", _pinRandom];
_serverName = "Gaming At Death's Door";		// Set your server name here to display in the messages.
_numberOfMags = 3;							// Set the number of magazines you wish to have spawn with weapons you give.

if (isNil "GADDventNumber") then
{
	["getGADDventNumber", [_uid]] call ExileClient_system_network_send;
};

_giftList = [];

if (_dayOfXmas == 25) then	// Set the gift selections for Christmas Day here.
{
	_giftList = [
	// ["Classname", Quantity], 
	// It does not matter the quantity of vehicles you give it, there will only ever be ONE spawned. Please also remember the same applies for weapons so just leave it at 1. Other items can have a number assigned.
	["srifle_LRR_tna_F", 1],
	["O_T_APC_Tracked_02_cannon_ghex_F", 1],         //Kamysh
	["I_APC_Tracked_03_cannon_F", 1],             //Mora tank APC gun
	["I_APC_Wheeled_03_cannon_F", 1],				//Gorgon
	["B_APC_Wheeled_01_cannon_F", 1],                //Marshall
	["srifle_GM6_ghex_F", 1],
	["srifle_GM6_camo_F", 1],
	["srifle_GM6_F", 1],
	["srifle_LRR_camo_F", 1],
	["srifle_LRR_F", 1],
	["Exile_Item_RubberDuck", 2]
	];
}
else						// Set the gift selection for the other days of the month here.
{
	_giftList = [
	["Exile_Car_Ifrit", 1],
	["Exile_Car_Hunter", 1],
	["Exile_Car_Strider", 1],
	["Exile_Item_Instadoc", 1],
	["Exile_Weapon_RPK", 1],
	["Exile_Weapon_PK", 1],
	["Exile_Weapon_PKP", 1],
	["Exile_Item_RubberDuck", 2]
	];
};

_sound = selectRandom [		// Music Array
	"weWishYouAMerryXmas",
	"AllIWantForXmas",
	"Fairytale",
	"HappyXmas",
	"JingleBellRock",
	"JingleBells",
	"LetItSnow",
	"LookLikeXmas",
	"Rudolph"
];

_daysNotAllowed = [26,27,28,29,30,31];

if (isNull unitBackpack player) exitWith 
{ 
 	["ErrorTitleAndText", ["GADDvent Calendar", "Please put on a backpack first!"]] call ExileClient_gui_toaster_addTemplateToast; 
};

if (GADDventOpening) exitWith
{
	["ErrorTitleAndText", ["GADDvent Calendar", "You can only open one at a time! Stop spamming!"]] call ExileClient_gui_toaster_addTemplateToast;
};

GADDventOpening = true;

if !(ExileServerStartTime select 1 == 12) exitWith
{
	["ErrorTitleAndText", ["GADDvent Calendar", "It's not even December yet, you scrub!"]] call ExileClient_gui_toaster_addTemplateToast;
	GADDventOpening = false;
};

if !(systemTime select 1 == 12) exitWith
{
	["ErrorTitleAndText", ["GADDvent Calendar", "It's not even December yet, you scrub!"]] call ExileClient_gui_toaster_addTemplateToast;
	GADDventOpening = false;
};

if (_dayOfXmas in _daysNotAllowed) exitWith
{
	["ErrorTitleAndText", ["GADDvent Calendar", "It's no longer GADDvent! We hope you had a great Christmas! And have a Happy New Year!"]] call ExileClient_gui_toaster_addTemplateToast;
	GADDventOpening = false;
};

_selectedGift = selectRandom _giftList;
_selectedGiftClass = _selectedGift select 0;
_selectedGiftQuantity = _selectedGift select 1;

_cfgClass = _selectedGiftClass call ExileClient_util_gear_getConfigNameByClassName;
_isVehicle = false;
_isWeapon = false;
_ammo = [];
_ammoSelect = "";
if (_cfgClass == "CfgVehicles") then
{
	_isVehicle = true;
}
else
{
	_isVehicle = false;
};

if (_cfgClass == "CfgWeapons") then
{
	_isWeapon = true;
}
else
{
	_isWeapon = false;
};

if (_isWeapon) then
{
	_ammo = getArray (configFile >> "CfgWeapons" >> _selectedGiftClass >> "magazines");
	_ammoSelect = selectRandom _ammo;
};

if (_dayOfXmas == GADDventNumber) exitWith 
{
	["ErrorTitleAndText", ["GADDvent Calendar", "You have already claimed your GADDvent gift today! Open your next one Tomorrow!"]]	call ExileClient_gui_toaster_addTemplateToast;
	GADDventOpening = false;
};

["InfoTitleAndText", ["GADDvent Calendar", "Opening Gift for today! Stand by!"]] call ExileClient_gui_toaster_addTemplateToast;

uiSleep 3;

_GADDventNumber = GADDventNumber;

if (_GADDventNumber > _dayOfXmas) exitWith
{
	["ErrorTitleAndText", ["GADDvent Calendar", "You seem to have opened too many gifts! Contact an Admin!"]] call ExileClient_gui_toaster_addTemplateToast;
	GADDventOpening = false;
};

if (_dayOfXmas == _GADDventNumber) exitWith
{
	["ErrorTitleAndText", ["GADDvent Calendar", "You have already claimed your GADDvent gift today! Open your next one Tomorrow!"]] call ExileClient_gui_toaster_addTemplateToast;
	GADDventOpening = false;
};

if (_GADDventNumber < _dayOfXmas) then
{
	if (_isVehicle) then
	{
		if (_dayOfXmas == 25) then 
		{
			["spawnGADDventVehicleRequest", [_selectedGiftClass,_pin]] call ExileClient_system_network_send;
			["SuccessTitleAndText", ["GADDvent Calendar", format ["MERRY CHRISTMAS! Thank you for playing %1! Enjoy the ride! PIN: %2", _serverName, _pin]]] call ExileClient_gui_toaster_addTemplateToast;
		}
		else
		{
			["spawnGADDventVehicleRequest", [_selectedGiftClass,_pin]] call ExileClient_system_network_send;
			["SuccessTitleAndText", ["GADDvent Calendar", format ["You have claimed your GADDvent gift for Today! Come back again tomorrow to claim another! Enjoy the ride! PIN: %1", _pin]]] call ExileClient_gui_toaster_addTemplateToast;
		};
	}
	else
	{
		if (_dayOfXmas == 25) then
		{
			if (_isWeapon) then
			{
				unitBackpack player addWeaponCargoGlobal [_selectedGiftClass, 1];
				unitBackpack player addMagazineCargoGlobal [_ammoSelect, _numberOfMags];	
			}
			else 
			{
				unitBackpack player addItemCargoGlobal [_selectedGiftClass, _selectedGiftQuantity];
			};
			["SuccessTitleAndText", ["GADDvent Calendar", format ["MERRY CHRISTMAS! Thank you for playing %1! Check your Backpack!", _serverName]]] call ExileClient_gui_toaster_addTemplateToast;
		}
		else
		{
			if (_isWeapon) then
			{
				unitBackpack player addWeaponCargoGlobal [_selectedGiftClass, 1];
				unitBackpack player addMagazineCargoGlobal [_ammoSelect, _numberOfMags];
			}
			else 
			{
				unitBackpack player addItemCargoGlobal [_selectedGiftClass, _selectedGiftQuantity];
			};
			["SuccessTitleAndText", ["GADDvent Calendar", "You just claimed a GADDvent Gift! Check your Backpack! Come back again tomorrow to claim your next gift!"]] call ExileClient_gui_toaster_addTemplateToast;
		};
	};
};

playSound _sound;
_newGADDventNumber = _dayOfXmas;
GADDventNumber = _newGADDventNumber;
["updateGADDventNumber", [_newGADDventNumber ,_uid]] call ExileClient_system_network_send;
GADDventOpening = false;
