"""
    rx_optimization_wrapper(;<keyword arguments>)

Wrap the optimization for RX gate

# Arguments
- `gamma::Real`: Rotation angle of RX
- `config_path::String`: path of the config JSON file
- `randomseed::Integer`: Seed to generate the initial parameters for optimization
- `initial_amplitude_relative_maximum::Real=0.01`: Max initial amplitude relative to pulse maximum(keyword arg)
- `is_baseline_initial_pulse_used::Bool=true`: Whether to add `cat(sign(gamma) * 0.5 * max_amplitude ones(D1), zeros(D1))` to the random initial values
- `verbose::Bool=false`: Whether to produce logging screen output (keyword arg)

# Returns
- `pcof`: optimizied parameters
"""
function rx_optimization_wrapper(;
    gamma::Real,
    config_path::String,
    randomseed::Integer,
    initial_amplitude_relative_maximum::Real=0.01,
    is_baseline_initial_pulse_used::Bool=true,
    verbose::Bool=false)

    parameter_dict = read_config(config_path);
    Nquditlevel = parameter_dict["Nquditlevel"];
    Nguardlevel = parameter_dict["Nguardlevel"];

    utarget = get_RX_unitary(
        gamma, Nquditlevel=Nquditlevel, Nguardlevel=Nguardlevel);
    juqbox_setup_dict = setup_juqbox_environment_from_config(
        utarget=utarget, config_path=config_path, verbose=verbose);

    # build a random initial parameters
    Random.seed!(randomseed);
    pulseamplitudemax = juqbox_setup_dict["pulseamplitudemax"]
    amplitudemax = initial_amplitude_relative_maximum * pulseamplitudemax;
    D1 = juqbox_setup_dict["D1"]
    pcof0 = get_random_parameter_vector(D1, amplitudemax);
    if is_baseline_initial_pulse_used
        pcof0 += sign(gamma) * 0.5 * pulseamplitudemax * vcat(ones(D1), zeros(D1))
    end
    pcof = Juqbox.run_optimizer(juqbox_setup_dict["prob"], pcof0);
    return pcof
end;

"""
    ry_optimization_wrapper(;<keyword arguments>)

Wrap the optimization for RY gate

# Arguments
- `gamma::Real`: Rotation angle of RY
- `config_path::String`: path of the config JSON file
- `randomseed::Integer`: Seed to generate the initial parameters for optimization
- `initial_amplitude_relative_maximum::Real=0.01`: Max initial amplitude relative to pulse maximum(keyword arg)
- `is_baseline_initial_pulse_used::Bool=true`: Whether to add `cat(sign(gamma) * 0.5 * max_amplitude ones(D1), zeros(D1))` to the random initial values
- `verbose::Bool=false`: Whether to produce logging screen output (keyword arg)

# Returns
- `pcof`: optimizied parameters
"""
function ry_optimization_wrapper(;
    gamma::Real,
    config_path::String,
    randomseed::Integer,
    initial_amplitude_relative_maximum::Real=0.01,
    is_baseline_initial_pulse_used::Bool=true,
    verbose::Bool=false)

    parameter_dict = read_config(config_path);
    Nquditlevel = parameter_dict["Nquditlevel"];
    Nguardlevel = parameter_dict["Nguardlevel"];

    utarget = get_RY_unitary(
        gamma, Nquditlevel=Nquditlevel, Nguardlevel=Nguardlevel);
    juqbox_setup_dict = setup_juqbox_environment_from_config(
        utarget=utarget, config_path=config_path, verbose=verbose);

    # build a random initial parameters
    Random.seed!(randomseed);
    pulseamplitudemax = juqbox_setup_dict["pulseamplitudemax"]
    amplitudemax = initial_amplitude_relative_maximum * pulseamplitudemax;
    D1 = juqbox_setup_dict["D1"]
    pcof0 = get_random_parameter_vector(D1, amplitudemax);
    #if is_baseline_initial_pulse_used
        pcof0 -= sign(gamma) * 0.5 * pulseamplitudemax * vcat(zeros(D1), ones(D1))
    #end
    pcof = Juqbox.run_optimizer(juqbox_setup_dict["prob"], pcof0);
    return pcof
end;

"""
    rz_optimization_wrapper(;<keyword arguments>)

Wrap the optimization for RZ gate

# Arguments
- `gamma::Real`: Rotation angle of RZ
- `config_path::String`: path of the config JSON file
- `randomseed::Integer`: Seed to generate the initial parameters for optimization
- `initial_amplitude_relative_maximum::Real=0.01`: Max initial amplitude relative to pulse maximum(keyword arg)
- `is_baseline_initial_pulse_used::Bool=true`: Whether to add `cat(sign(gamma) * 0.5 * max_amplitude ones(D1), zeros(D1))` to the random initial values
- `verbose::Bool=false`: Whether to produce logging screen output (keyword arg)

# Returns
- `pcof`: optimizied parameters
"""
function rz_optimization_wrapper(;
    gamma::Real,
    config_path::String,
    randomseed::Integer,
    initial_amplitude_relative_maximum::Real=0.01,
    is_baseline_initial_pulse_used::Bool=true,
    verbose::Bool=false)

    parameter_dict = read_config(config_path);
    Nquditlevel = parameter_dict["Nquditlevel"];
    Nguardlevel = parameter_dict["Nguardlevel"];

    utarget = get_RZ_unitary(
        gamma, Nquditlevel=Nquditlevel, Nguardlevel=Nguardlevel);
    juqbox_setup_dict = setup_juqbox_environment_from_config(
        utarget=utarget, config_path=config_path, verbose=verbose);

    # build a random initial parameters
    Random.seed!(randomseed);
    pulseamplitudemax = juqbox_setup_dict["pulseamplitudemax"]
    amplitudemax = initial_amplitude_relative_maximum * pulseamplitudemax;
    D1 = juqbox_setup_dict["D1"]
    pcof0 = get_random_parameter_vector(D1, amplitudemax);
    if is_baseline_initial_pulse_used
        pcof0 += sign(gamma) * 0.5 * pulseamplitudemax * vcat(ones(D1), zeros(D1))
    end

    pcof = Juqbox.run_optimizer(juqbox_setup_dict["prob"], pcof0);
    return pcof
end;

"""
    ugate_optimization_wrapper(;<keyword arguments>)

Wrap the optimization for UGate
UGate = [[cos(theta/2), -e^{i lam} sin(theta/2)],
         [e^{i phi} sin(theta/2), e^{i (phi+lam)} cos(theta/2)]]

# Arguments
- `theta::Real`: Eular angle
- `phi::Real`: Eular angle
- `lam::Real`: Eular angle
- `config_path::String`: path of the config JSON file
- `randomseed::Integer`: Seed to generate the initial parameters for optimization
- `initial_amplitude_relative_maximum::Real=0.01`: Max initial amplitude relative to pulse maximum(keyword arg)
- `verbose::Bool=false`: Whether to produce logging screen output (keyword arg)

# Returns
- `pcof`: optimizied parameters
"""
function ugate_optimization_wrapper(;
    theta::Real,
    phi::Real,
    lam::Real,
    config_path::String,
    randomseed::Integer,
    initial_amplitude_relative_maximum::Real=0.01,
    verbose::Bool=false)

    parameter_dict = read_config(config_path);
    Nquditlevel = parameter_dict["Nquditlevel"];
    Nguardlevel = parameter_dict["Nguardlevel"];

    utarget = get_ugate_unitary(
        theta, phi, lam, Nquditlevel=Nquditlevel, Nguardlevel=Nguardlevel);
    juqbox_setup_dict = setup_juqbox_environment_from_config(
        utarget=utarget, config_path=config_path, verbose=verbose);

    # build a random initial parameters
    Random.seed!(randomseed);
    amplitudemax = initial_amplitude_relative_maximum * juqbox_setup_dict["pulseamplitudemax"];
    D1 = juqbox_setup_dict["D1"]
    pcof0 = get_random_parameter_vector(D1, amplitudemax);

    pcof = Juqbox.run_optimizer(juqbox_setup_dict["prob"], pcof0);
    return pcof
end;


"""
    setup_juqbox_environment_from_config(utarget, config_path)

Setup the juqbox environment using a config file

# Arguments
- `utarget::Matrix{Number}`: Target Unitary in the lab frame (keyword arg)
- `config_path::String`: path of the config JSON file
"""
function setup_juqbox_environment_from_config(;
        utarget::Matrix{ComplexF64},
        config_path::String,
        verbose::Bool=false)
    parameter_dict = read_config(config_path);

    Tgate = parameter_dict["Tgate"];
    D1 = parameter_dict["D1"];
    pulseamplitudemax = parameter_dict["pulseamplitudemax"];

    Nquditlevel = parameter_dict["Nquditlevel"];
    Nguardlevel = parameter_dict["Nguardlevel"];
    qubitfreq = parameter_dict["qubitfreq"];
    qubitanharmonicity = parameter_dict["qubitanharmonicity"];

    Pmin = parameter_dict["Pmin"];

    maxIter = parameter_dict["maxIter"];
    lbfgsMax = parameter_dict["lbfgsMax"];
    ipTol = parameter_dict["ipTol"];
    acceptTol = parameter_dict["acceptTol"];
    acceptIter = parameter_dict["acceptIter"];

    prob, params, wa = setup_juqbox_environment(
        Tgate=Tgate,
        D1=D1,
        pulseamplitudemax=pulseamplitudemax,
        utarget=utarget,
        Nquditlevel=Nquditlevel,
        Nguardlevel=Nguardlevel,
        qubitfreq=qubitfreq,
        qubitanharmonicity=qubitanharmonicity,
        Pmin=Pmin,
        maxIter=maxIter,
        lbfgsMax=lbfgsMax,
        ipTol=ipTol,
        acceptTol=acceptTol,
        acceptIter=acceptIter,
        verbose=verbose
    );
    juqbox_setup_dict = Dict(
        "prob" => prob,
        "params" => params,
        "wa" => wa,
        "D1" => D1,
        "pulseamplitudemax" => pulseamplitudemax
    )
    return juqbox_setup_dict
end;
