#ifndef _INCLUDED_CCS_PROBES_H_
#define _INCLUDED_CCS_PROBES_H_

#include <systemc.h>
#include <string>
#include <tlm.h>
#include <mc_typeconv.h>

// traits class to handle extracting bitwidth of probed data
template <class T> struct ccs_scverify_probe_traits;
template <>
struct ccs_scverify_probe_traits< bool > {
  typedef sc_lv<1> data_type;
  enum {lvwidth = 1};
};
template <>
struct ccs_scverify_probe_traits< char > {
  typedef sc_lv<8> data_type;
  enum {lvwidth = 8};
};
template <>
struct ccs_scverify_probe_traits< unsigned char > {
  typedef sc_lv<8> data_type;
  enum {lvwidth = 8};
};
template <>
struct ccs_scverify_probe_traits< short > {
  typedef sc_lv<16> data_type;
  enum {lvwidth = 16};
};
template <>
struct ccs_scverify_probe_traits< unsigned short > {
  typedef sc_lv<16> data_type;
  enum {lvwidth = 16};
};
template <>
struct ccs_scverify_probe_traits< int > {
  typedef sc_lv<32> data_type;
  enum {lvwidth = 32};
};
template <>
struct ccs_scverify_probe_traits< unsigned int > {
  typedef sc_lv<32> data_type;
  enum {lvwidth = 32};
};
template <>
struct ccs_scverify_probe_traits< long > {
  typedef sc_lv<32> data_type;
  enum {lvwidth = 32};
};
template <>
struct ccs_scverify_probe_traits< unsigned long > {
  typedef sc_lv<32> data_type;
  enum {lvwidth = 32};
};
template <>
struct ccs_scverify_probe_traits< long long > {
  typedef sc_lv<64> data_type;
  enum {lvwidth = 64};
};
template <>
struct ccs_scverify_probe_traits< unsigned long long > {
  typedef sc_lv<64> data_type;
  enum {lvwidth = 64};
};
template <int Tlvwidth>
struct ccs_scverify_probe_traits< sc_lv<Tlvwidth> > {
  typedef sc_lv<Tlvwidth> data_type;
  enum {lvwidth = Tlvwidth};
};
template <int Twidth>
struct ccs_scverify_probe_traits< sc_bv<Twidth> > {
  typedef sc_lv<Twidth> data_type;
  enum {lvwidth = Twidth};
};
template <int Twidth>
struct ccs_scverify_probe_traits< sc_int<Twidth> > {
  typedef sc_lv<Twidth> data_type;
  enum {lvwidth = Twidth};
};
template <int Twidth>
struct ccs_scverify_probe_traits< sc_uint<Twidth> > {
  typedef sc_lv<Twidth> data_type;
  enum {lvwidth = Twidth};
};
template <int Twidth>
struct ccs_scverify_probe_traits< sc_bigint<Twidth> > {
  typedef sc_lv<Twidth> data_type;
  enum {lvwidth = Twidth};
};
template <int Twidth>
struct ccs_scverify_probe_traits< sc_biguint<Twidth> > {
  typedef sc_lv<Twidth> data_type;
  enum {lvwidth = Twidth};
};
#ifdef SC_INCLUDE_FX
template <int Twidth, int Ibits>
struct ccs_scverify_probe_traits< sc_fixed<Twidth,Ibits> > {
  typedef sc_lv<Twidth> data_type;
  enum {lvwidth = Twidth};
};
template <int Twidth, int Ibits, sc_q_mode Qmode, sc_o_mode Omode, int Nbits>
struct ccs_scverify_probe_traits< sc_fixed<Twidth,Ibits,Qmode,Omode,Nbits> > {
  typedef sc_lv<Twidth> data_type;
  enum {lvwidth = Twidth};
};
template <int Twidth, int Ibits>
struct ccs_scverify_probe_traits< sc_ufixed<Twidth,Ibits> > {
  typedef sc_lv<Twidth> data_type;
  enum {lvwidth = Twidth};
};
template <int Twidth, int Ibits, sc_q_mode Qmode, sc_o_mode Omode, int Nbits>
struct ccs_scverify_probe_traits< sc_ufixed<Twidth,Ibits,Qmode,Omode,Nbits> > {
  typedef sc_lv<Twidth> data_type;
  enum {lvwidth = Twidth};
};
#endif
#ifdef __AC_INT_H
template <int Twidth>
struct ccs_scverify_probe_traits< ac_int<Twidth,true> > {
  typedef sc_lv<Twidth> data_type;
  enum {lvwidth = Twidth};
};
template <int Twidth>
struct ccs_scverify_probe_traits< ac_int<Twidth,false> > {
  typedef sc_lv<Twidth> data_type;
  enum {lvwidth = Twidth};
};
#endif
#ifdef __AC_FIXED_H
template <int Twidth, int Ibits, bool Signed, ac_q_mode Qmode, ac_o_mode Omode>
struct ccs_scverify_probe_traits< ac_fixed<Twidth,Ibits,Signed,Qmode,Omode> > {
  typedef sc_lv<Twidth> data_type;
  enum {lvwidth = Twidth};
};
#endif
#ifdef __AC_FLOAT_H
template <int MTbits, int MIbits, int Ebits, ac_q_mode Qmode>
struct ccs_scverify_probe_traits< ac_float<MTbits,MIbits,Ebits,Qmode> > {
  typedef sc_lv<MTbits+Ebits> data_type;
  enum {lvwidth = MTbits+Ebits};
};
#endif


// Generic function - specializations follow
template <int Tw>
inline void ccs_probe_fifo_put(std::string prbnm, sc_lv<Tw> &val) {  }

// making this function inlined will result in each C++ file getting a copy of the function(s) but this
// guarantees that all templatized expansions of the function are generated
#endif
