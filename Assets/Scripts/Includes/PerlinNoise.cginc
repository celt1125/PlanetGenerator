// Reference: https://github.com/motudev/3dperlinNoiseTut/blob/master/Assets/perlinNoise.cs

int permutation[512] = {
	151,160,137, 91, 90, 15,131, 13,201, 95, 96, 53,194,233,  7,225,
	140, 36,103, 30, 69,142,  8, 99, 37,240, 21, 10, 23,190,  6,148,
	247,120,234, 75,  0, 26,197, 62, 94,252,219,203,117, 35, 11, 32,
	 57,177, 33, 88,237,149, 56, 87,174, 20,125,136,171,168, 68,175,
	 74,165, 71,134,139, 48, 27,166, 77,146,158,231, 83,111,229,122,
	 60,211,133,230,220,105, 92, 41, 55, 46,245, 40,244,102,143, 54,
	 65, 25, 63,161,  1,216, 80, 73,209, 76,132,187,208, 89, 18,169,
	200,196,135,130,116,188,159, 86,164,100,109,198,173,186,  3, 64,
	 52,217,226,250,124,123,  5,202, 38,147,118,126,255, 82, 85,212,
	207,206, 59,227, 47, 16, 58, 17,182,189, 28, 42,223,183,170,213,
	119,248,152,  2, 44,154,163, 70,221,153,101,155,167, 43,172,  9,
	129, 22, 39,253, 19, 98,108,110, 79,113,224,232,178,185,112,104,
	218,246, 97,228,251, 34,242,193,238,210,144, 12,191,179,162,241,
	 81, 51,145,235,249, 14,239,107, 49,192,214, 31,181,199,106,157,
	184, 84,204,176,115,121, 50, 45,127,  4,150,254,138,236,205, 93,
	222,114, 67, 29, 24, 72,243,141,128,195, 78, 66,215, 61,156,180,

	151,160,137, 91, 90, 15,131, 13,201, 95, 96, 53,194,233,  7,225,
	140, 36,103, 30, 69,142,  8, 99, 37,240, 21, 10, 23,190,  6,148,
	247,120,234, 75,  0, 26,197, 62, 94,252,219,203,117, 35, 11, 32,
	 57,177, 33, 88,237,149, 56, 87,174, 20,125,136,171,168, 68,175,
	 74,165, 71,134,139, 48, 27,166, 77,146,158,231, 83,111,229,122,
	 60,211,133,230,220,105, 92, 41, 55, 46,245, 40,244,102,143, 54,
	 65, 25, 63,161,  1,216, 80, 73,209, 76,132,187,208, 89, 18,169,
	200,196,135,130,116,188,159, 86,164,100,109,198,173,186,  3, 64,
	 52,217,226,250,124,123,  5,202, 38,147,118,126,255, 82, 85,212,
	207,206, 59,227, 47, 16, 58, 17,182,189, 28, 42,223,183,170,213,
	119,248,152,  2, 44,154,163, 70,221,153,101,155,167, 43,172,  9,
	129, 22, 39,253, 19, 98,108,110, 79,113,224,232,178,185,112,104,
	218,246, 97,228,251, 34,242,193,238,210,144, 12,191,179,162,241,
	 81, 51,145,235,249, 14,239,107, 49,192,214, 31,181,199,106,157,
	184, 84,204,176,115,121, 50, 45,127,  4,150,254,138,236,205, 93,
	222,114, 67, 29, 24, 72,243,141,128,195, 78, 66,215, 61,156,180
};
int permutationCount = 255;

float3 directions[16] = {
	float3( 1, 1, 0),
	float3(-1, 1, 0),
	float3( 1,-1, 0),
	float3(-1,-1, 0),
	float3( 1, 0, 1),
	float3(-1, 0, 1),
	float3( 1, 0,-1),
	float3(-1, 0,-1),
	float3( 0, 1, 1),
	float3( 0,-1, 1),
	float3( 0, 1,-1),
	float3( 0,-1,-1),
	float3( 1, 1, 0),
	float3(-1, 1, 0),
	float3( 0,-1, 1),
	float3( 0,-1,-1)
};
int directionCount = 15;

float smoothDistance(float d)
{
	return d * d * d * (d * (d * 6 - 15) + 10);
}

float PerlinNoise3D(float3 p)
{
	int flooredPointX0 = floor(p.x);
	int flooredPointY0 = floor(p.y);
	int flooredPointZ0 = floor(p.z);

	float distanceX0 = p.x - flooredPointX0;
	float distanceY0 = p.y - flooredPointY0;
	float distanceZ0 = p.z - flooredPointZ0;

	float distanceX1 = distanceX0 - 1;
	float distanceY1 = distanceY0 - 1;
	float distanceZ1 = distanceZ0 - 1;

	flooredPointX0 &= permutationCount;
	flooredPointY0 &= permutationCount;
	flooredPointZ0 &= permutationCount;

	int flooredPointX1 = flooredPointX0 + 1;
	int flooredPointY1 = flooredPointY0 + 1;
	int flooredPointZ1 = flooredPointZ0 + 1;

	int permutationX0 = permutation[flooredPointX0];
	int permutationX1 = permutation[flooredPointX1];

	int permutationY00 = permutation[permutationX0 + flooredPointY0];
	int permutationY10 = permutation[permutationX1 + flooredPointY0];
	int permutationY01 = permutation[permutationX0 + flooredPointY1];
	int permutationY11 = permutation[permutationX1 + flooredPointY1];
	/*
			int permutationZ000 = permutation[permutationY00 + flooredPointZ0];
			int permutationZ100 = permutation[permutationY10 + flooredPointZ0];
			int permutationZ010 = permutation[permutationY01 + flooredPointZ0];
			int permutationZ110 = permutation[permutationY11 + flooredPointZ0];
			int permutationZ001 = permutation[permutationY00 + flooredPointZ1];
			int permutationZ101 = permutation[permutationY01 + flooredPointZ1];
			int permutationZ011 = permutation[permutationY10 + flooredPointZ1];
			int permutationZ111 = permutation[permutationY11 + flooredPointZ1];
	*/
	float3 direction000 = directions[permutation[permutationY00 + flooredPointZ0] & directionCount];
	float3 direction100 = directions[permutation[permutationY10 + flooredPointZ0] & directionCount];
	float3 direction010 = directions[permutation[permutationY01 + flooredPointZ0] & directionCount];
	float3 direction110 = directions[permutation[permutationY11 + flooredPointZ0] & directionCount];
	float3 direction001 = directions[permutation[permutationY00 + flooredPointZ1] & directionCount];
	float3 direction101 = directions[permutation[permutationY10 + flooredPointZ1] & directionCount];
	float3 direction011 = directions[permutation[permutationY01 + flooredPointZ1] & directionCount];
	float3 direction111 = directions[permutation[permutationY11 + flooredPointZ1] & directionCount];

	/*
			float3 direction000 = directions[permutationZ000 & directionCount];
			float3 direction100 = directions[permutationZ100 & directionCount];
			float3 direction010 = directions[permutationZ010 & directionCount];
			float3 direction110 = directions[permutationZ110 & directionCount];
			float3 direction001 = directions[permutationZ001 & directionCount];
			float3 direction101 = directions[permutationZ101 & directionCount];
			float3 direction011 = directions[permutationZ011 & directionCount];
			float3 direction111 = directions[permutationZ111 & directionCount];
	*/

	float value000 = dot(direction000, float3(distanceX0, distanceY0, distanceZ0));
	float value100 = dot(direction100, float3(distanceX1, distanceY0, distanceZ0));
	float value010 = dot(direction010, float3(distanceX0, distanceY1, distanceZ0));
	float value110 = dot(direction110, float3(distanceX1, distanceY1, distanceZ0));
	float value001 = dot(direction001, float3(distanceX0, distanceY0, distanceZ1));
	float value101 = dot(direction101, float3(distanceX1, distanceY0, distanceZ1));
	float value011 = dot(direction011, float3(distanceX0, distanceY1, distanceZ1));
	float value111 = dot(direction111, float3(distanceX1, distanceY1, distanceZ1));

	float smoothDistanceX = smoothDistance(distanceX0);
	float smoothDistanceY = smoothDistance(distanceY0);
	float smoothDistanceZ = smoothDistance(distanceZ0);

	return lerp(
		lerp(lerp(value000, value100, smoothDistanceX), lerp(value010, value110, smoothDistanceX), smoothDistanceY),
		lerp(lerp(value001, value101, smoothDistanceX), lerp(value011, value111, smoothDistanceX), smoothDistanceY),
		smoothDistanceZ);
}