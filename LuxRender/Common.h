#include "LuxMax.h"

float Mtl_GetFloat(MtlBase* base, TSTR pr, TimeValue t);
int Mtl_GetInt(MtlBase* base, TSTR pr, TimeValue t);
TSTR Mtl_GetStr(MtlBase* base, TSTR pr, TimeValue t);
Point3 Mtl_GetColor(MtlBase* base, TSTR pr, TimeValue t);
Texmap* Mtl_GetTexmap(MtlBase* base, TSTR pr, TimeValue t);
void CommaScan(TCHAR* buf);
TSTR Format(float value);