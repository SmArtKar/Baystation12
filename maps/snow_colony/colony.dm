#if TRUE
	//#include "example_areas.dm"
	//#include "example_shuttles.dm"
	//#include "example_unit_testing.dm"

	#include "colony_define.dm"

	#include "colony-1.dmm"
	#include "colony-2.dmm"
	#include "colony-3.dmm"

	#define using_map_DATUM /datum/map/colony

#elif !defined(MAP_OVERRIDE)

	#warn A map has already been included, ignoring Colony

#endif