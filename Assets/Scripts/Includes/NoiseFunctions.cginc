#include "/SimplexNoise.cginc"

float SNoise(float3 position){
	return snoise(position);
}

float SimplexNoise(float3 position, int layers, float frequency, float amplitude, float lacunarity, float persistence){
	float res = 0;
	for (int i = 0; i < layers; i++){
		res += snoise(position * frequency) * amplitude;
		frequency *= lacunarity;
		amplitude *= persistence;
	}
	return res;
}

float RidgedNoise(float3 position, int layers, float frequency, float amplitude, float lacunarity,
					float persistence, float power, float gain){
	float res = 0;
	float ridge_weight = 1;

	for (int i = 0; i < layers; i++){
		float noise_value = pow(abs(1 - abs(snoise(position * frequency))), power) * ridge_weight;
		ridge_weight = saturate(noise_value * gain);
		res += noise_value * amplitude;
		frequency *= lacunarity;
		amplitude *= persistence;
	}
	return res;
}

float SmoothMax(float a, float b, float k){
	k = min(0, -k);
	float h = max(0, min(1, (b - a + k) / (2 * k)));
	return a * h + b * (1 - h) - k * h * (1 - h);
}

float SmoothedRidgedNoise(float3 position, int layers, float frequency, float amplitude, float lacunarity,
					float persistence, float power, float gain, float smoothness){
	float3 normed_pos = normalize(position);
	float3 axis1 = cross(normed_pos, float3(0,1,0)); // decreased as lititude increases
	float3 axis2 = cross(normed_pos, axis1);
	
	float res = 0;
	res += RidgedNoise(position, layers, frequency, amplitude, lacunarity, persistence, power, gain);
	res += RidgedNoise(position - axis1 * smoothness, layers, frequency, amplitude, lacunarity, persistence, power, gain);
	res += RidgedNoise(position + axis1 * smoothness, layers, frequency, amplitude, lacunarity, persistence, power, gain);
	res += RidgedNoise(position - axis2 * smoothness, layers, frequency, amplitude, lacunarity, persistence, power, gain);
	res += RidgedNoise(position + axis2 * smoothness, layers, frequency, amplitude, lacunarity, persistence, power, gain);
	
	return res * 0.2f;
}

float NoiseShift(float noise, float a, float b){
	return noise * a + b;
}