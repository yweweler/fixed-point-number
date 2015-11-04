#include <stdio.h>
#include <stdint.h>

// extern int heming_dist(int, int);
// 
// extern void build_stack_frame_manual();
// extern void build_stack_frame_auto();

extern long long genepsilon();
extern long long genshift(unsigned char scale);
extern long long genfracmask(unsigned char scale);
extern long long genfloormask(unsigned char scale);

extern long long int2fixed(long long n, unsigned char scale);
extern long long fixed2int(long long n, unsigned char scale);

extern long long fixed_fraction(long long n, unsigned char scale);
extern long long fixed_floor(long long n, unsigned char scale);

extern long long double2fixed(double n, unsigned char scale);
extern double fixed2double(long long n, unsigned char scale);


int main(int argc, char **argv) {
	const double pi = 3.141596;

	printf("<<< x64 ASM Sandbox >>>\n\n");

	// debug("heming distance of 2783, 1552", -1, hemming_dist(2783, 1552));

	// /* ~25% faster then a enter/leave */
	// build_stack_frame_manual();		
	// build_stack_frame_auto();
	
	
	printf("double2fixed(%e, 16) = %lld\n", pi, double2fixed(pi, 16));

	printf("fixed2double(fixed_fraction(double2fixed(%e, 32), 32), 32) = %e\n", pi,
	    fixed2double(fixed_fraction(double2fixed(pi, 32), 32), 32));

	// printf("fixed2double(fixed_floor(double2fixed(%e, 16), 16), 16) = %e\n\n", pi,
	// 	fixed2double(fixed_floor(double2fixed(3.141596, 16), 16), 16));
	
    printf("epsilon = %llu\n", genepsilon());
	printf("fixed2double(epsilon,  2) ASM = %G\n", fixed2double(genepsilon(),  2));
	printf("fixed2double(epsilon,  4) ASM = %G\n", fixed2double(genepsilon(),  4));
	printf("fixed2double(epsilon,  8) ASM = %G\n", fixed2double(genepsilon(),  8));
	printf("fixed2double(epsilon, 16) ASM = %G\n", fixed2double(genepsilon(), 16));
	printf("fixed2double(epsilon, 32) ASM = %G\n", fixed2double(genepsilon(), 32));
	printf("fixed2double(epsilon, 48) ASM = %G\n", fixed2double(genepsilon(), 48));
	printf("fixed2double(epsilon, 60) ASM = %G\n", fixed2double(genepsilon(), 60));

	return 0;
}
