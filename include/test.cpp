///
/// This file is supplementary material for the paper:
///
/// "A Fast Incremental BSP Tree Archive for Non-dominated Points"
/// Tobias Glasmachers, 9th International Conference on Evolutionary
/// Multi-Criterion Optimization (EMO), 2017.
///
///
/// Copyright (c) 2016 Tobias Glasmachers
/// All rights reserved.
/// 
/// Redistribution and use in source and binary forms, with or without
/// modification, are permitted provided that the following conditions
/// are met:
/// 
/// 1. Redistributions of source code must retain the above copyright
/// notice, this list of conditions and the following disclaimer.
/// 
/// 2. Redistributions in binary form must reproduce the above copyright
/// notice, this list of conditions and the following disclaimer in the
/// documentation and/or other materials provided with the distribution.
/// 
/// 3. Neither name of copyright holders nor the names of its contributors
/// may be used to endorse or promote products derived from this software
/// without specific prior written permission.
/// 
/// 
/// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
/// ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
/// LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
/// A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE REGENTS OR
/// CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
/// EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
/// PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
/// PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
/// LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
/// NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
/// SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
///

// enable counters; disable for time measurement
//#define COUNTER

// output statistics
#define VERBOSE


#include "paretoarchive.h"

const double M_PI = 3.1415;
using namespace std;

// number of objectives
#define NUM_OBJ 3

// Gaussian distribution on objective vectors with zero mean
// and unit (co)variance, but zero variance in direction (1, ..., 1).
template <int OBJ>
ObjVec<OBJ> gaussvec()
{
	ObjVec<OBJ> g;
	double s = 0.0;
	for (unsigned int j=0; j<OBJ; j++)
	{
		s += g[j] = sin(2.0 * M_PI * (rand() + 0.5) / (RAND_MAX + 1.0)) * sqrt(-2.0 * log((rand() + 0.5) / (RAND_MAX + 1.0)));
	}
	s /= OBJ;
	for (unsigned int j=0; j<OBJ; j++) g[j] -= s;
	return g;
}

// Create sequence of objective vectors consisting of N non-dominated
// points and D dominated points. A parameter value of c > 1 encodes a
// preference for placing non-dominated points to the start of the
// sequence. The distance d controls how far dominated points are behind
// the front.
template <int OBJ>
vector<ObjVec<OBJ>> sampleSequence(unsigned int N, unsigned int D, double c, double d)
{
	unsigned int n = N + D;
	BspTreeArchive<OBJ> front;
	vector<ObjVec<OBJ>> data(n);

	// create non-dominated points
	for (unsigned int i=0; i<N; i++)
	{
		data[D + i] = gaussvec<OBJ>();
		front.process(data[D + i]);
	}
	assert(front.size() == N);

	for (unsigned int i=0; i<n; i++)
	{
		if ((rand() + 0.5) / (RAND_MAX + 1.0) * (N + D) < D * c)
		{
			// create a dominated point
			assert(D > 0);
			double dist = d * n / (i+1.0);
			ObjVec<OBJ> p;
			while (true)
			{
				p = gaussvec<OBJ>();
				for (unsigned int j=0; j<OBJ; j++) p[j] += dist;
				if (front.dominated(p)) break;
			}
			data[i] = p;
			D--;
		}
		else
		{
			// insert non-dominated point
			assert(N > 0);
			data[i] = data[n - N];
			N--;
		}
	}
	assert(N == 0);
	assert(D == 0);
	return data;
}


int main(int argc, char** argv)
{
	// experiment characteristics
	unsigned int runs = 1;            // number of repetitions for robust time measurement
	unsigned int n = 0;               // number of points in the sequence
	unsigned int N = 10000;           // number of non-dominated points
	double c = 1.0;                   // preference for sampling dominated points early on
	double d = 0.01;                  // distance of dominated points from the front

	for (int a=1; a<argc; a++)
	{
		string arg = argv[a];
		if (arg == "runs")
		{
			a++;
			if (a >= argc) throw runtime_error("invalid command line argument: runs not given");
			runs = strtol(argv[a], nullptr, 10);
		}
		else if (arg == "n")
		{
			a++;
			if (a >= argc) throw runtime_error("invalid command line argument: n not given");
			n = strtol(argv[a], nullptr, 10);
		}
		else if (arg == "N")
		{
			a++;
			if (a >= argc) throw runtime_error("invalid command line argument: N not given");
			N = strtol(argv[a], nullptr, 10);
		}
		else if (arg == "c")
		{
			a++;
			if (a >= argc) throw runtime_error("invalid command line argument: c not given");
			c = strtod(argv[a], nullptr);
		}
		else if (arg == "d")
		{
			a++;
			if (a >= argc) throw runtime_error("invalid command line argument: d not given");
			d = strtod(argv[a], nullptr);
		}
		else if (arg == "balance")
		{
			a++;
			if (a >= argc) throw runtime_error("invalid command line argument: balance threshold not given");
			balance_tree = true;
			balance_threshold = strtod(argv[a], nullptr);
		}
		else if (arg == "no-balance")
		{
			balance_tree = false;
		}
		else throw runtime_error("invalid command line argument; " + arg);
	}
	if (n < N) n = N;
	unsigned int D = n - N;

#ifdef VERBOSE
	cout << "settings:" << endl;
	cout << "  objectives: " << NUM_OBJ << endl;
	cout << "  runs: " << runs << endl;
	cout << "  n: " << n << endl;
	cout << "  D: " << D << endl;
	cout << "  N: " << N << endl;
	cout << "  c: " << c << endl;
	cout << "  d: " << d << endl;
	cout << "  balance: " << (balance_tree ? "yes" : "no") << endl;
	cout << "  balance-threshold: " << balance_threshold << endl;
	cout << endl;
#endif

	// create sequence of objective vectors
	vector<ObjVec<NUM_OBJ>> data = sampleSequence<NUM_OBJ>(N, D, c, d);

	{
#ifdef VERBOSE
		cout << "BSP TREE ARCHIVE" << endl;
#endif
#ifdef COUNTER
		cmp_counter = 0;
		cell_counter = 0;
		delete_counter = 0;
#endif
		double seconds = 0.0;
		for (unsigned int run=0; run<runs; run++)
		{
			clock_t start = clock();
			BspTreeArchive<NUM_OBJ> front;
			for (unsigned int i=0; i<n; i++) front.process(data[i]);
			clock_t finish = clock();
			seconds += (double)(finish - start) / (double)CLOCKS_PER_SEC;

			if (run == runs-1)
			{
#ifdef VERBOSE
				cout << "  " << front.size() << " points were found to be non-dominated (the front)" << endl;
				cout << "    in " << seconds / (double)runs << " seconds" << endl;
#ifdef COUNTER
				cout << "    with " << cmp_counter / (double)runs << " comparisons" << endl;
				cout << "    visiting " << cell_counter / (double)n / (double)runs << " cells on average per insertion" << endl;
				cout << "      (a fraction of " << cell_counter / (n * (double)n) / (double)runs << " of all points)" << endl;
				cout << "    " << delete_counter / (double)runs << " intermediate cells deleted" << endl;
#endif
				cout << "tree depth: " << front.treedepth() << ", minimal tree depth: " << ceil(1.0 + log(front.size() / (double)bucket_size) / log(2.0)) << endl;
#endif
			}
vector<const ObjVec<NUM_OBJ>*> datax = front.points();
		}

	}

#if NUM_OBJ == 2
#ifdef VERBOSE
	cout << endl;
#endif

	{
#ifdef VERBOSE
		cout << "BI-OBJECTIVE ARCHIVE" << endl;
#endif
#ifdef COUNTER
		cmp_counter = 0;
		cell_counter = 0;
		delete_counter = 0;
#endif
		double seconds = 0.0;
		for (unsigned int run=0; run<runs; run++)
		{
			clock_t start = clock();
			BiObjectiveArchive front;
			for (unsigned int i=0; i<n; i++) front.process(data[i]);
			clock_t finish = clock();
			seconds += (double)(finish - start) / (double)CLOCKS_PER_SEC;
			if (run == runs - 1)
			{
#ifdef VERBOSE
				cout << "  " << front.size() << " points were found to be non-dominated (the front)" << endl;
				cout << "    in " << seconds / (double)runs << " seconds" << endl;
#ifdef COUNTER
				cout << "    with " << cmp_counter / (double)runs << " comparisons" << endl;
				cout << "    visiting " << cell_counter / (double)n / (double)runs << " cells on average per insertion" << endl;
				cout << "      (a fraction of " << cell_counter / (n * (double)n) / (double)runs << " of all points)" << endl;
				cout << "    " << delete_counter / (double)runs << " intermediate cells deleted" << endl;
#endif
#endif
			}
		}
	}
#endif

#ifdef VERBOSE
	cout << endl;
#endif

	{
#ifdef VERBOSE
		cout << "VECTOR ARCHIVE" << endl;
#endif
#ifdef COUNTER
		cmp_counter = 0;
		cell_counter = 0;
		delete_counter = 0;
#endif
		double seconds = 0.0;
		for (unsigned int run=0; run<runs; run++)
		{
			clock_t start = clock();
			LinearMemoryArchive<NUM_OBJ> front;
			for (unsigned int i=0; i<n; i++) front.process(data[i]);
			clock_t finish = clock();
			seconds += (double)(finish - start) / (double)CLOCKS_PER_SEC;
			if (run == runs - 1)
			{
#ifdef VERBOSE
				cout << "  " << front.size() << " points were found to be non-dominated (the front)" << endl;
				cout << "    in " << seconds / (double)runs << " seconds" << endl;
#ifdef COUNTER
				cout << "    with " << cmp_counter / (double)runs << " comparisons" << endl;
				cout << "    visiting " << cell_counter / (double)n / (double)runs << " cells on average per insertion" << endl;
				cout << "      (a fraction of " << cell_counter / (n * (double)n) / (double)runs << " of all points)" << endl;
				cout << "    " << delete_counter / (double)runs << " intermediate cells deleted" << endl;
#endif
#endif
			}
		}
	}
}
