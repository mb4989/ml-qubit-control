using JSON


"""
    read_config(path)

Read parameters from the config JSON file
"""
function read_config(path::String)
    config_s = open(f->read(f, String), path);
    config_dict = JSON.parse(config_s);

    parameter_dict = Dict{}();  # output dictionary

    # config parameters
    # pulse parameters
    # Gate duration in ns
    parameter_dict["Tgate"] = config_dict["pulse_parameters"]["Tgate"];
    parameter_dict["pulseamplitudemax"] = config_dict["pulse_parameters"]["pulseamplitudemax"];
    # Number of B-spline coefficients per frequency, sin/cos and real/imag
    parameter_dict["D1"] = config_dict["pulse_parameters"]["D1"];

    # qubit parameters
    parameter_dict["Nquditlevel"] = config_dict["qubit_parameters"]["Nquditlevel"];
    parameter_dict["Nguardlevel"] = config_dict["qubit_parameters"]["Nguardlevel"];
    # Qubit frequency in GHz
    parameter_dict["qubitfreq"] = config_dict["qubit_parameters"]["qubitfreq"];
    # Qubit anharmonicity in GHz
    parameter_dict["qubitanharmonicity"] = config_dict["qubit_parameters"]["qubitanharmonicity"];

    # simulation parameters
    parameter_dict["Pmin"] = config_dict["simulation_parameters"]["Pmin"];

    # optimization parameters
    # Maximum number of iterations to be taken by optimizer
    parameter_dict["maxIter"] = config_dict["optimization_parameters"]["maxIter"];
    # Maximum number of past iterates for Hessian approximation by L-BFGS
    parameter_dict["lbfgsMax"] = config_dict["optimization_parameters"]["lbfgsMax"];
    # Desired convergence tolerance (relative)
    parameter_dict["ipTol"] = config_dict["optimization_parameters"]["ipTol"];
    # Acceptable convergence tolerance (relative)
    parameter_dict["acceptTol"] = config_dict["optimization_parameters"]["acceptTol"];
    # Number of acceptable iterates before triggering termination
    parameter_dict["acceptIter"] = config_dict["optimization_parameters"]["acceptIter"];

    # other parameters
    parameter_dict["version"] = config_dict["other_parameters"]["version"];
    return parameter_dict
end;
