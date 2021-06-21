
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


#include <cassert>
#include <cmath>
#include <ctime>
#include <string>
#include <vector>
#include <map>
#include <algorithm>
#include <iostream>
#include <string.h>

#ifdef _MSC_VER

#if _MSC_VER < 1600 //MSVC version <8
     #include "nullptr_emulation.h"
#endif


typedef __int32 int32_t;
typedef unsigned __int32 uint32_t;
typedef __int64 int64_t;
typedef unsigned __int64 uint64_t;

#else
#include <stdint.h>
#endif


using namespace std;

// bucket size of the BSP tree
static const unsigned int bucket_size = 20;


// tree balancing parameters
bool balance_tree = true;
double balance_threshold = 6.0;


#ifdef COUNTER
uint64_t cmp_counter = 0;       // number of comparisons of components of objective vectors
uint64_t cell_counter = 0;      // number of visited cells
uint64_t delete_counter = 0;    // number of cell removals
#endif


// fixed-size vector of doubles, here objective space vectors
template <int OBJ>
class ObjVec
{
public:
	ObjVec(int id=0)
	{ m_id=id; memset(m_data, 0, sizeof(m_data)); }

//	ObjVec(ObjVec const& other) = default; // NEFUNGUJE V MSVC

	template <class VEC>
	ObjVec(VEC const& other)
	{
		assert(other.size() == OBJ);
		for (unsigned int i=0; i<OBJ; i++) m_data[i] = other[i];
      m_id = 0;
	}

//	ObjVec& operator = (ObjVec const& other) = default; // NEFUNGUJE V MSVC

	double& operator [] (unsigned int index)
	{ return m_data[index]; }
	double const& operator [] (unsigned int index) const
	{ return m_data[index]; }
	double& operator () (unsigned int index)
	{ return m_data[index]; }
	double const& operator () (unsigned int index) const
	{ return m_data[index]; }

	bool operator == (ObjVec<OBJ> const& other) const
	{
		for (unsigned int i=0; i<OBJ; i++) if (m_data[i] != other[i]) return false;
		return true;
	}
	bool operator != (ObjVec<OBJ> const& other) const
	{ return ! (operator == (other)); }

	static int dominance(ObjVec<OBJ> const& x, ObjVec<OBJ> const& y)
	{
		int ret = 3;
		for (unsigned int i=0; i<OBJ; i++)
		{
#ifdef COUNTER
			cmp_counter++;
#endif
			if (x[i] < y[i]) ret &= 1;
			else if (x[i] > y[i]) ret &= 2;
			if (ret == 0) return 0;
		}
		return ret;
	}

	bool operator < (ObjVec<OBJ> const& other) const
	{ return dominance(*this, other) == 1; }
	bool operator <= (ObjVec<OBJ> const& other) const
	{ return dominance(*this, other) & 1; }
	bool operator > (ObjVec<OBJ> const& other) const
	{ return dominance(*this, other) == 2; }
	bool operator >= (ObjVec<OBJ> const& other) const
	{ return dominance(*this, other) & 2; }

   int getId(void) 
   { return m_id; }

   void setId(int id)
   { m_id = id; }

private:
	double m_data[OBJ];
   int m_id;
};


// simplistic archive class based on a linear memory vector
template <int OBJ>
class LinearMemoryArchive
{
public:
	bool process(ObjVec<OBJ> const& y)
	{
		for (unsigned int j=0; j<m_vector.size(); j++)
		{
			ObjVec<OBJ> const& yj = m_vector[j];
			int rel = ObjVec<OBJ>::dominance(y, yj);
#ifdef COUNTER
			cell_counter++;
#endif
			if (rel & 2) return false;   // yj <= y
			else if (rel == 1)           // y < yj
			{
#ifdef COUNTER
				delete_counter++;
#endif
				m_vector[j] = m_vector.back();
				m_vector.pop_back();
				j--;
			}
		}
		m_vector.push_back(y);
		return true;
	}

	unsigned int empty() const
	{ return m_vector.empty(); }
	unsigned int size() const
	{ return m_vector.size(); }

	vector<ObjVec<2>> const& points() const
	{ return m_vector; }

private:
	vector<ObjVec<OBJ>> m_vector;
};


// specific Bi-objective archive class based on a balanced search tree
class BiObjectiveArchive
{
public:
	bool process(ObjVec<2> const& y)
	{
		// check whether y is weakly dominated
		MapType::iterator worse = m_map.upper_bound(y[0]);
		if (worse != m_map.begin())
		{
			MapType::iterator better = worse;
			if (better == m_map.end()) --better;
			else
			{
#ifdef COUNTER
				cmp_counter++;
#endif
				if (better->first > y[0]) --better;
			}
			assert(better != m_map.end() && better->first <= y[0]);
#ifdef COUNTER
			cmp_counter++;
#endif
			if (better->second <= y[1]) return false;
		}

		// remove dominated points
		assert(worse == m_map.end() || worse->first >= y[0]);
#ifdef COUNTER
		cmp_counter++;
#endif
		while (worse != m_map.end())
		{
#ifdef COUNTER
		cmp_counter++;
#endif
			if (worse->second < y[1]) break;

			MapType::iterator it = worse;
			++worse;
			m_map.erase(it);
#ifdef COUNTER
			delete_counter++;
			cell_counter++;
#endif
		}

		// insert y
		m_map[y[0]] = y[1];
		return true;
	}

	unsigned int empty() const
	{ return m_map.empty(); }
	unsigned int size() const
	{ return m_map.size(); }

	vector<ObjVec<2>> points() const
	{
		vector<ObjVec<2>> ret(m_map.size());
		unsigned int i = 0;
		for (MapType::const_iterator it = m_map.begin(); it != m_map.end(); ++it)
		{
			ret[i](0) = it->first;
			ret[i](1) = it->second;
			i++;
		}
		return ret;
	}

private:
	struct Comparator
	{
		bool operator () (double x, double y) const
		{
#ifdef COUNTER
			cmp_counter++;
			cell_counter++;
#endif
			return (x < y);
		}
	};

	typedef map<double, double, Comparator> MapType;
	MapType m_map;
};


// archive class based on a BSP tree
template <int OBJ>
class BspTreeArchive
{
public:
	BspTreeArchive()
	: m_root(new LeafNode())
	{ }

	~BspTreeArchive()
	{ delete m_root; }

	bool empty() const
	{ return m_root->empty(); }
	unsigned int size() const
	{ return m_root->size(); }
	unsigned int treedepth() const
	{ return m_root->depth(); }

	vector<const ObjVec<OBJ>*> points() const
	{
		vector<const ObjVec<OBJ>*> ret(m_root->size());
		unsigned int index = 0;
		m_root->extract(ret, index);
		return ret;
	}

	void clear()
	{
		delete m_root;
		m_root = new LeafNode();
	}

	bool process(ObjVec<OBJ> const& y)
	{
		// check for dominance and remove all dominated points
		if (checkDominance(m_root, y, 0, 0) == -1) return false;
		if (m_root->m_size == 0) clear();

		// insert the new point
		InteriorNode* interior = insert(m_root, y);

		// check tree balance
		if (balance_tree && interior)
		{
			// obtain "large" and "small" branch of the tree
			Node* large = (interior->m_left->m_size > interior->m_right->m_size) ? interior->m_left : interior->m_right;
			Node* small = (interior->m_left->m_size < interior->m_right->m_size) ? interior->m_left : interior->m_right;
			if (large->leaf()) return true;   // don't balance leaves

			// replace interior with large
			large->m_parent = interior->m_parent;
			if (interior->m_parent)
			{
				if (interior->m_parent->m_left == interior) interior->m_parent->m_left = large;
				else interior->m_parent->m_right = large;
			}
			else m_root = large;
			interior->m_left = nullptr;
			interior->m_right = nullptr;
			delete interior;

			// move points from small into large subtree
			vector<const ObjVec<OBJ>*> list(small->m_size);
			unsigned int index = 0;
			small->extract(list, index);
			for (unsigned int i=0; i<list.size(); i++) insert(large, *list[i]);
			delete small;
		}

		return true;
	}

	bool dominated(ObjVec<OBJ> const& y) const
	{ return recDominated(y, m_root, 0, 0); }

private:
	struct InteriorNode;

	struct Node
	{
		Node(bool interior)
		: m_parent(nullptr)
		, m_size(0)
		, m_interior(interior)
		{ }

		virtual ~Node()
		{
#ifdef COUNTER
			delete_counter++;
#endif
		}


		bool empty() const
		{ return (m_size == 0); }
		unsigned int size() const
		{ return m_size; }
		bool leaf() const
		{ return (! m_interior); }
		bool interior() const
		{ return (m_interior); }

		virtual unsigned int depth() const = 0;
		virtual void extract(vector<const ObjVec<OBJ>*>& list, unsigned int& index) const = 0;

		InteriorNode* m_parent;             // parent node or nullptr
		unsigned int m_size;                // number of points in the sub-tree

	private:
		bool m_interior;                    // is this an interior node or a leaf node?
	};

	struct LeafNode : public Node
	{
		LeafNode()
		: Node(false)
		{ }

		unsigned int depth() const
		{ return 1; }

		void extract(vector<const ObjVec<OBJ>*>& list, unsigned int& index) const
		{
			for (unsigned int i=0; i<Node::m_size; i++) list[index++] = &m_point[i];
		}

		ObjVec<OBJ> m_point[bucket_size];   // objective vectors represented by this node
	};

	struct InteriorNode : public Node
	{
		InteriorNode()
		: Node(true)
		{ }

		~InteriorNode()
		{
			delete m_left;
			delete m_right;
		}

		unsigned int depth() const
		{ return max(m_left->depth(), m_right->depth()) + 1; }

		double unbalanceFactor() const
		{
			double m = min(m_left->m_size, m_right->m_size);
			double M = max(m_left->m_size, m_right->m_size);
			return (M / m);
		}

		void extract(vector<const ObjVec<OBJ>*>& list, unsigned int& index) const
		{
			m_left->extract(list, index);
			m_right->extract(list, index);
		}

		Node* m_left;                       // left (better) child node
		Node* m_right;                      // right (worse) child node
		double m_threshold;                 // coordinate value for splitting between left and right
		unsigned int m_objective;           // coordinate axis to which threshold, min, and max refer
	};

	// Insert the point into the sub-tree.
	// The method does not change the size field of ancestor nodes.
	// It does not balance the tree, however, it returns a non-null
	// pointer if that node needs balancing.
	// Note: the method may modify the node pointer (passed by reference).
	InteriorNode* insert(Node*& node, ObjVec<OBJ> const& y)
	{
#ifdef COUNTER
		cell_counter++;
#endif
		if (node->interior())
		{
			InteriorNode* interior = static_cast<InteriorNode*>(node);
			interior->m_size++;
#ifdef COUNTER
			cmp_counter++;
#endif
			InteriorNode* ret = insert((y[interior->m_objective] < interior->m_threshold) ? interior->m_left : interior->m_right, y);
			return (interior->unbalanceFactor() > balance_threshold) ? interior : ret;
		}
		else
		{
			LeafNode* leaf = static_cast<LeafNode*>(node);

			if (leaf->m_size < bucket_size)
			{
				leaf->m_point[leaf->m_size] = y;
				leaf->m_size++;
				return nullptr;
			}
			else
			{
				// split the leaf
				assert(leaf->m_size == bucket_size);
				LeafNode* l = new LeafNode();
				LeafNode* r = new LeafNode();

				// find objective for split
				vector<unsigned int> dj(OBJ, numeric_limits<unsigned int>::max());
				unsigned int d = 1;
				for (InteriorNode* nn = leaf->m_parent; nn; nn=nn->m_parent, d++) dj[nn->m_objective] = min(dj[nn->m_objective], d);
				unsigned int j = 0;
				for (unsigned int jj=1; jj<OBJ; jj++) if (dj[jj] > dj[j]) j = jj;
				double value[bucket_size + 1];
				while (true)
				{
					// extract set of values
					for (unsigned int i=0; i<bucket_size; i++) value[i] = leaf->m_point[i](j);
					value[bucket_size] = y(j);
					sort(value, value + bucket_size + 1);
					if (value[bucket_size] > value[0]) break;
					// select the next best objective
					dj[j] = 0;
					j = 0;
					for (unsigned int jj=1; jj<OBJ; jj++) if (dj[jj] > dj[j]) j = jj;
				}

				// find split point
				int nl = (bucket_size + 1) / 2;
				assert(nl >= 1);
				int below = nl, above = nl;
				while (below >= 0 && value[below] == value[nl]) below--;
				while (above <= (int)bucket_size && value[above] == value[nl]) above++;
				assert(below >= 0 || above <= bucket_size);
				if (below + 1 > (int)bucket_size + 1 - above) nl = below + 1;
				else nl = above;
				assert(value[nl-1] < value[nl]);
				double theta = 0.5 * (value[nl-1] + value[nl]);

				// insert points into leaves
				for (unsigned int i=0; i<bucket_size; i++)
				{
					if (leaf->m_point[i](j) < theta)
					{
						l->m_point[l->m_size] = leaf->m_point[i];
						l->m_size++;
					}
					else
					{
						r->m_point[r->m_size] = leaf->m_point[i];
						r->m_size++;
					}
				}
				if (y(j) < theta)
				{
					l->m_point[l->m_size] = y;
					l->m_size++;
				}
				else
				{
					r->m_point[r->m_size] = y;
					r->m_size++;
				}
				assert(l->m_size == nl);
				assert(r->m_size == bucket_size + 1 - nl);

				// create new interior node
				InteriorNode* interior = new InteriorNode();
				interior->m_left = l;
				interior->m_right = r;
				interior->m_size = bucket_size + 1;
				interior->m_objective = j;
				interior->m_threshold = theta;
				interior->m_parent = leaf->m_parent;
				l->m_parent = interior;
				r->m_parent = interior;

				// destroy old leaf node
				delete leaf;

				// change the external pointer to keep parent-child relations consistent
				node = interior;

				// don't try to balance the new node
				return nullptr;
			}
		}
	}

	// return value:
	// -1 if y is dominated by the sub-tree represented by the node,
	// the number of dominated and removed points if y is non-dominated.
	int checkDominance(Node* node, ObjVec<OBJ> const& y, uint64_t B, uint64_t W)
	{
		static_assert(OBJ <= 63, "[checkDominance] the code supports 'only' up to 63 objectives");

#ifdef COUNTER
		cell_counter++;
#endif
		int ret = 0;

		if (node->leaf())
		{
			LeafNode* leaf = static_cast<LeafNode*>(node);

			for (unsigned int i=0; i<leaf->m_size; i++)
			{
				int d = ObjVec<OBJ>::dominance(leaf->m_point[i], y);
				if (d & 1)
				{
					assert(ret == 0);
					return -1;
				}
				else if (d == 2)
				{
					leaf->m_point[i] = leaf->m_point[leaf->m_size - 1];
					leaf->m_size--;
					i--;
					ret++;
				}
			}
		}
		else
		{
			InteriorNode* interior = static_cast<InteriorNode*>(node);

			uint64_t BB = B;
			uint64_t WW = W;
			if (y[interior->m_objective] < interior->m_threshold) BB |= (((uint64_t)1) << interior->m_objective);
			else WW |= (((uint64_t)1) << interior->m_objective);

			// recurse into left sub-tree
			if (WW == 0 || B == 0)
			{
				if (WW == (((uint64_t)1) << OBJ) - 1)
				{
					// point is dominated
					assert(ret == 0);
					return -1;
				}
				else
				{
					// recurse
					int result = checkDominance(interior->m_left, y, B, WW);
					if (result == -1)
					{
						assert(ret == 0);
						return -1;
					}
					if (result > 0)
					{
						ret += result;
						if (interior->m_left->empty())
						{
							delete interior->m_left;
							interior->m_left = nullptr;
						}
					}
				}
			}

			// recurse into right sub-tree
			if (W == 0 || BB == 0)
			{
				if (BB == (((uint64_t)1) << OBJ) - 1)
				{
					// whole space cell is dominated
					ret += interior->m_right->m_size;
					delete interior->m_right;
					interior->m_right = nullptr;
				}
				else
				{
					// recurse
					int result = checkDominance(interior->m_right, y, BB, W);
					if (result == -1)
					{
						assert(ret == 0);
						return -1;
					}
					if (result > 0)
					{
						ret += result;
						if (interior->m_right->empty())
						{
							delete interior->m_right;
							interior->m_right = nullptr;
						}
					}
				}
			}

			interior->m_size -= ret;

			if (ret > 0)
			{
				// make sure that the binary tree remains valid
				assert(interior->m_left || interior->m_right || interior->m_size == 0);
				Node* tmp = nullptr;
				if (! interior->m_right && interior->m_left) tmp = interior->m_left;
				else if (! interior->m_left && interior->m_right) tmp = interior->m_right;
				if (tmp)
				{
					assert(tmp->m_parent == node);
					assert(interior->m_size == tmp->m_size);

					// replace interior with tmp
					tmp->m_parent = interior->m_parent;
					if (interior->m_parent)
					{
						if (interior->m_parent->m_left == interior) interior->m_parent->m_left = tmp;
						else interior->m_parent->m_right = tmp;
					}
					else m_root = tmp;
					interior->m_left = nullptr;
					interior->m_right = nullptr;
					delete interior;
				}
			}
		}
		return ret;
	}

	bool recDominated(ObjVec<OBJ> const& y, Node* node, uint64_t B, uint64_t W) const
	{
		if (! node) node = m_root;

		if (node->leaf())
		{
			LeafNode* leaf = static_cast<LeafNode*>(node);

			for (unsigned int i=0; i<leaf->m_size; i++)
			{
				int d = ObjVec<OBJ>::dominance(leaf->m_point[i], y);
				if (d & 1) return true;
				else if (d == 2) return false;
			}
		}
		else
		{
			InteriorNode* interior = static_cast<InteriorNode*>(node);

			uint64_t BB = B;
			uint64_t WW = W;
			if (y[interior->m_objective] < interior->m_threshold) BB |= (((uint64_t)1) << interior->m_objective);
			else WW |= (((uint64_t)1) << interior->m_objective);

			// recurse into left sub-tree
			if (WW == 0 || B == 0)
			{
				if (WW == (((uint64_t)1) << OBJ) - 1) return true;
				else if (recDominated(y, interior->m_left, B, WW)) return true;
			}

			// recurse into right sub-tree
			if (W == 0 || BB == 0)
			{
				if (BB == (((uint64_t)1) << OBJ) - 1) return false;
				else if (recDominated(y, interior->m_right, BB, W)) return true;
			}
		}
		return false;
	}

	Node* m_root;
};
