#include <stdio.h>
#include <grass/gis.h>
#include "raster3d_intern.h"

/*--------------------------------------------------------------------------*/


/*!
 * \brief 
 *
 * The default resampling function which uses nearest
 * neighbor resampling. This method converts the window coordinates
 * x, y, and z into region coordinates and returned the nearest neighbor.
 *
 *  \param map
 *  \param col
 *  \param row
 *  \param depth
 *  \param value
 *  \param type
 *  \return void
 */

void
G3d_nearestNeighbor(RASTER3D_Map * map, int x, int y, int z, void *value,
		    int type)
{
    double north, east, top;
    int row, col, depth;

    /* convert (x, y, z) window coordinates into (north, east, top) */
    G3d_coord2location(&(map->window), (double)x + 0.5, (double)y + 0.5, (double)z + 0.5, &north, &east, &top);

    /* convert (north, east, top) into map region coordinates (row, col, depth) */
    G3d_location2coord(&(map->region), north, east, top, &col, &row, &depth);

    /* if (row, col, depth) outside map region return NULL value */
    if ((row < 0) || (row >= map->region.rows) ||
	(col < 0) || (col >= map->region.cols) ||
	(depth < 0) || (depth >= map->region.depths)) {
	G3d_setNullValue(value, 1, type);
	return;
    }
    
    /* Get the value from the map in map-region resolution */
	G3d_getValueRegion(map, col, row, depth, value, type);
}

/*--------------------------------------------------------------------------*/


/*!
 * \brief 
 *
 * Sets the resampling function to be used by
 * G3d_getValue () (cf.{g3d:G3d.getValue}). This function is defined
 * as follows:
 *
 *  \return void
 */

void G3d_setResamplingFun(RASTER3D_Map * map, void (*resampleFun) ())
{
    map->resampleFun = resampleFun;
}

/*--------------------------------------------------------------------------*/


/*!
 * \brief 
 *
 * 
 * Returns in <em>resampleFun</em> a pointer to the resampling function used by
 * <em>map</em>.
 *
 *  \return void
 */

void G3d_getResamplingFun(RASTER3D_Map * map, void (**resampleFun) ())
{
    *resampleFun = map->resampleFun;
}

/*--------------------------------------------------------------------------*/


/*!
 * \brief 
 *
 *  Returns
 * in <em>nnFunPtr</em> a pointer to G3d_nearestNeighbor () (cf.{g3d:G3d.nearestNeighbor}).
 *
 *  \return void
 */

void G3d_getNearestNeighborFunPtr(void (**nnFunPtr) ())
{
    *nnFunPtr = G3d_nearestNeighbor;
}
