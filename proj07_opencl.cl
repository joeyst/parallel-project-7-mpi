
#define PI (3.14159265358979323846)
#define sinf(x) (float)sine((double)(x))
#define IN
#define OUT

float sine(int);
float cosine(int);
float power(float, int);
int fact(int);
#define TERMS (1)

// Source: https://stackoverflow.com/questions/38917692/sin-cos-funcs-without-math-h
//////
float sine(int deg) {
    deg %= 360; // make it less than 360
    float rad = deg * PI / 180;
    float sin = 0;

    int i;
    for(i = 0; i < TERMS; i++) { // That's Taylor series!!
        sin += power(-1, i) * power(rad, 2 * i + 1) / fact(2 * i + 1);
    }
    return sin;
}

float cosine(int deg) {
    deg %= 360; // make it less than 360
    float rad = deg * PI / 180;
    float cos = 0;

    int i;
    for(i = 0; i < TERMS; i++) { // That's also Taylor series!!
        cos += power(-1, i) * power(rad, 2 * i) / fact(2 * i);
    }
    return cos;
}

float power(float base, int exp) {
    if(exp < 0) {
        if(base == 0)
            return -0; // Error!!
        return 1 / (base * power(base, (-exp) - 1));
    }
    if(exp == 0)
        return 1;
    if(exp == 1)
        return base;
    return base * power(base, exp - 1);
}

int fact(int n) {
    return n <= 0 ? 1 : n * fact(n-1);
}
//////

kernel
void
DoOneLocalFourier( IN global const float *dSignal, IN global const int *dWorkPerProcessor, IN global const int *dMaxPeriods, OUT global float *dEachSums )
{
	// Passing in (ONE, TWO) args: 
	// An [sub]array of floats (*dSignal) 
	// A length of the signal (*dWorkPerProcessor)
	// Max periods (*dMaxPeriods)
	// Writing to ONE arg: 
	// An array of floats (*dEachSums)

	int WorkPerProcessor = *dWorkPerProcessor;
	int MaxPeriods       = *dMaxPeriods; 
	int ProcessorID      = get_local_id( 0 );
	int SignalOffset     = ProcessorID * WorkPerProcessor;
	int SumsOffset       = ProcessorID * MaxPeriods;

	for( int p = 1; p < MaxPeriods; p++ )
	{
		int SumsIndex = p + SumsOffset;
		dEachSums[SumsIndex] = 0.;
	}

	for( int p = 1; p < MaxPeriods; p++ )
	{
		float omega = ((float)(2.*M_PI))/(float)p;;
		for ( int t = 0; t < WorkPerProcessor; t++ ) {
			int SignalIndex = t + SignalOffset;
			int SumsIndex = t + SumsOffset;
			float time = (float)SignalIndex;
			// Omega is interval of frequency that we're checking 
			// Omega * time is the current point in time that we're looking at(?) 
			// Sum up the signal times the current point in time(?) 
			dEachSums[SumsIndex] += dSignal[SignalIndex] * sinf( omega*time );
		}
	}
}
