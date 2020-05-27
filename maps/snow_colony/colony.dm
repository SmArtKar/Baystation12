#if TRUE
	//#include "example_areas.dm"
	//#include "example_shuttles.dm"
	//#include "example_unit_testing.dm"

	#include "colony_define.dm"

	#include "colony1-peak.dmm"
	#include "colony2-surface.dmm"
	#include "colony3-ground.dmm"

	#define using_map_DATUM /datum/map/colony

#elif !defined(MAP_OVERRIDE)

	#warn A map has already been included, ignoring Colony

#endif