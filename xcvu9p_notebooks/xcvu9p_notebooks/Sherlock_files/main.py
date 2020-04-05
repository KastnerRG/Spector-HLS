#!/usr/bin/env python

import os
import argparse
# DO NOT IMPORT HERE


def main():

    ####### Parameters #######

    parser = argparse.ArgumentParser(description="Run the Sherlock algorithm")

    sherlock_group = parser.add_argument_group("Sherlock")
    sherlock_group.add_argument("-i", "--input-file", default='../example_data/slambench_orbslam2.csv',
                            help='Path to the input file (default: %(default)s)')
    sherlock_group.add_argument("-nis", "--num-init-samples", default=2, type=int,
                            help='Number of initial samples (default: %(default)s)')
    sherlock_group.add_argument("-n", "--num-designs", default=0.31, type=float,
                            help='Total number of designs to sample (if in [0.0 .. 1.0], percentage of design candidates) (default: %(default)s)')
    sherlock_group.add_argument("-s", "--surrogate", default="rbfthin_plate",
                            help='Type of surrogate model: (gpy[multi][sparse], gphodlr, rbf[basis], randomforest, or gp) (default: %(default)s)')
    sherlock_group.add_argument("-k", "--kernel", default="matern",
                            help='Type of kernel: gpy: [matern, rbf]; gphodlr: [matern]; gp:[matern, rationalquadratic] (default: %(default)s)')
    sherlock_group.add_argument("-onr", "--opt-num-restarts", default=0, type=int,
                            help='Number of restarts for kernel optimization (only for gpy) (default: %(default)s)')
    sherlock_group.add_argument("-ted", "--ted-in-loop",
                            help='Use TED in the active learning loop (default: %(default)s)',
                            action='store_true')
    sherlock_group.add_argument("-no-rescale", "--no-rescale", help="Disable rescaling the queried values based on the initial samples.", action='store_true')
    sherlock_group.add_argument("-no-rescale-in", "--no-rescale-input", help="Disable rescaling the input values.", action='store_true')
    sherlock_group.add_argument("-noise", "--noise", default=0.0, type=float,
                            help="Add random noise on the output space (y) based on this factor multiplied by the std on each axis. (default: %(default)s)")
    sherlock_group.add_argument("-mul", "--mul", default=[1], type=float,
                                help='Multiplication factor for the output space (default: %(default)s)', nargs='+')
    sherlock_group.add_argument("-poly", "--poly-features", default=1, type=int, help="Generate polynomial features of degree n from the input values. (default: %(default)s)")
    sherlock_group.add_argument("-trace-prior", "--trace-prior", help="When using pymc3, use trace from previous iteration as prior for the new model.", action='store_true')
    sherlock_group.add_argument("-mst", "--model-selection-type", default="mab10", help="Model selection type: mab[factor] or all. (default: %(default)s)")
    sherlock_group.add_argument("-action-only", "--action-only", default=None, help=argparse.SUPPRESS)

    hint_group = parser.add_argument_group("Hint")
    hint_group.add_argument("-hint", "--hint", help='Use hint data (default: %(default)s) [Surrogate must be gpy]]',
                            action='store_true')
    hint_group.add_argument("-ht", "--hint-type", default="gpu",
                            help="Type of hint (gpu, esttp, cpu, random). (default: %(default)s)")
    hint_group.add_argument("-hnoise", "--hint-noise", default=0.0, type=float,
                            help="Add random noise to hint data based on this factor multiplied by the hint std on each axis. (default: %(default)s)")
    hint_group.add_argument("-hmul", "--hint-mul", default=[1], type=float,
                            help='Multiplication factor for the hint output space (default: %(default)s)', nargs='+')
    hint_group.add_argument("-hni", "--hint-ninit", default=0, type=int,
                            help='Number of initial samples from hint data (in addition to --num-init-samples) (default: %(default)s)')

    plot_group = parser.add_argument_group("Plotting/Output")
    plot_group.add_argument("-q", "--quiet", help='Disable printing except for the end result (default: %(default)s)', action='store_true')
    sherlock_group.add_argument("-o", "--output", default="", help='Output to a file instead of terminal')

    misc_group = parser.add_argument_group("Other options")
    misc_group.add_argument("-nt", "--num-threads", default=1, type=int,
                            help='Attempt to set the number of threads (default: %(default)s)')
    misc_group.add_argument("-nr", "--num-runs", default=1, type=int,
                            help='Number of times to run the algorithm [NOTE: this will reload data and re-apply new random noise if selected] (default: %(default)s)')

    args = parser.parse_args()




    inputFilename  = args.input_file
    numInit        = args.num_init_samples
    budget         = args.num_designs
    useTedInLoop   = args.ted_in_loop
    useHint        = args.hint
    hintType       = args.hint_type
    hintNoise      = args.hint_noise
    scaleSpace     = not args.no_rescale
    scaleInput     = not args.no_rescale_input
    surrogateType  = args.surrogate
    kernel         = args.kernel
    numRestarts    = args.opt_num_restarts
    printError     = "" if args.quiet else "adrs,pareto_score,next_action,model,time"
    outputFilename = args.output
    numRuns        = max(1, args.num_runs)
    numThreads     = args.num_threads
    noise          = args.noise
    multFactor     = args.mul
    hintMultFactor = args.hint_mul
    numHintInit    = args.hint_ninit
    numPoly        = args.poly_features
    tracePrior     = args.trace_prior
    modelSelType   = args.model_selection_type

    # Set environment variables
    os.environ['OMP_NUM_THREADS']     = str(numThreads)
    os.environ['MKL_NUM_THREADS']     = str(numThreads)
    os.environ['NUMEXPR_NUM_THREADS'] = str(numThreads)
    if numThreads == 1:
        os.environ['MKL_THREADING_LAYER'] = 'SEQUENTIAL'

    # Then import libraries
    from Sherlock import Sherlock
    from utils import adrs, read_design_space
    import numpy as np
    from sklearn.preprocessing import PolynomialFeatures, scale


    # Output / Print
    text_to_print = "filename,n_init,budget,use_ted,noise,use_hint,hint_type,hint_random_factor," \
                    "surrogate,kernel,num_restarts,num_runs,num_threads," \
                    "rescale,num_hint_init,num_poly,scale_input," \
                    "trace_prior,model_sel_type\n"
    text_to_print += ",".join(["\"" + inputFilename + "\"",
                               str(numInit), str(budget), str(useTedInLoop), str(noise), str(useHint), str(hintType), str(hintNoise),
                               str(surrogateType), str(kernel), str(numRestarts), str(numRuns), str(numThreads),
                               str(scaleSpace), str(numHintInit), str(numPoly), str(scaleInput),
                               str(tracePrior), str(modelSelType)])

    if outputFilename:
        with open(outputFilename, 'wt') as ofile:
            ofile.write(text_to_print + "\n")
    else:
        print(text_to_print)


    # Loop for multiple runs
    for irun in range(numRuns):

        # Read data
        X, y, yh = read_design_space(inputFilename, random_factor=noise, use_hint=useHint, hint_type=hintType, hint_random_factor=hintNoise, mult_factor=multFactor, hint_mult_factor=hintMultFactor)

        X = X.copy() + 1.01

        if scaleInput:
            X = scale(X.astype(np.float64))

        poly = PolynomialFeatures(numPoly)
        X = poly.fit_transform(X)[:,1:]

        if budget <= 1.0:
            budget = int(X.shape[0] * budget)
        else: budget = int(max(numInit, budget))


        # Initialize Sherlock
        sherlock = Sherlock(n_init=numInit,
                            budget=budget,
                            surrogate_type=surrogateType,
                            kernel=kernel,
                            num_restarts=numRestarts,
                            pareto_margin=0,
                            y_hint=yh,
                            output_stats=printError,
                            output_filename=outputFilename,
                            plot_design_space=False,
                            use_ted_in_loop=useTedInLoop,
                            request_output=lambda y, idx: None,
                            action_only=args.action_only,
                            scale_output=scaleSpace,
                            n_hint_init=numHintInit,
                            use_trace_as_prior=tracePrior,
                            model_selection_type=modelSelType,
                            )

        try:
            # Run Sherlock
            sherlock.fit(X).predict(X, y)

            # Print final results
            err = adrs(y, sherlock.known_idx, approximate=True)
            finalNumSamples = len(sherlock.known_idx)
            print(",".join(map(str, [finalNumSamples, finalNumSamples/X.shape[0], err])))
        except KeyboardInterrupt: raise
        except Exception as e:
            print("ERROR: " + str(e))
            continue


if __name__ == "__main__":
    main()
