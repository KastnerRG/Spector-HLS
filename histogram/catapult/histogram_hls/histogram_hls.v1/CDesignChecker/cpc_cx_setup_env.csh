#! /bin/csh -f
setenv SYSTEMC_HOME /usr/local/bin/Mentor_Graphics/Catapult_Synthesis_10.4-828904/Mgc_home/shared
setenv SYSTEMC_LIB_DIR /usr/local/bin/Mentor_Graphics/Catapult_Synthesis_10.4-828904/Mgc_home/shared/lib
setenv CXX_FLAGS "-g -DCALYPTO_SKIP_SYSTEMC_VERSION_CHECK"
setenv LD_FLAGS "-lpthread"
setenv OSSIM ddd
setenv PATH /usr/local/bin/Mentor_Graphics/Catapult_Synthesis_10.4-828904/Mgc_home/bin:$PATH
