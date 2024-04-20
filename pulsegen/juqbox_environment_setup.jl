using LinearAlgebra
using Random
using Juqbox


"""
    get_random_parameter_vector(D1, amplitudemax; <keyword arguments>)

Get a random parameter vector to be the initial state of optimization

# Arguments
- `D1::Integer,`: Number of B-spline coefficients per frequency, sin/cos and real/imag
- `amplitudemax::Real`: Maximum amplitude of the random vector
- `Nctrl::Integer=1`: Number of control channels (keyword arg)
- `Nfreq::Integer=1`: Number of frequency components per control channel (keyword arg)
"""
function get_random_parameter_vector(
        D1::Integer,
        amplitudemax::Real;
        Nctrl::Integer=1,
        Nfreq::Integer=1)
    nCoeff = 2 * Nctrl * Nfreq * D1 # factor '2' is for sin/cos
    pcof0 = amplitudemax * rand(nCoeff)
    return pcof0
end;


"""
    setup_juqbox_environment(;<keyword arguments>)

Setup Juqbox environment for analysis and optimal control

# Arguments
- `Tgate`: Duration of gate in ns (keyword arg)
- `D1::Integer,`: Number of B-spline coefficients per frequency, sin/cos and real/imag  (keyword arg)
- `pulseamplitudemax`: Maximum pulse amplitudes allowed for p(t) and q(t) (keyword arg)
- `utarget::Matrix{Number}`: Target Unitary in the lab frame (keyword arg)
- `qubitfreq::Real`: qubit regular frequency in GHz (keyword arg)
- `qubitanharmonicity::Real` qubit regular frequency anharmonicity in GHz (keyword arg)
- `Pmin::Real` Number of time steps per shortest period or sample rate assuming a slowly varying Hamiltonian (keyword arg)
- `Nquditlevel::Integer=2`: Number of essential energy levels (keyword arg)
- `Nguardlevel::Integer=0`: Number of guard energy levels (keyword arg)
- `maxIter:: Int64=100`: Maximum number of iterations to be taken by optimizer (keyword arg)
- `lbfgsMax:: Int64=10`: Maximum number of past iterates for Hessian approximation by L-BFGS (keyword arg)
- `ipTol:: Float64=1e-5`: Desired convergence tolerance (relative) (keyword arg)
- `acceptTol:: Float64=15`: Acceptable convergence tolerance (relative) (keyword arg)
- `acceptIter:: Int64=15`: Number of acceptable iterates before triggering termination (keyword arg)
- `nodes:: Array{Float64, 1}=[0.0]`: Risk-neutral opt: User specified quadrature nodes on the interval [-ϵ,ϵ] for some ϵ (keyword arg)
- `weights:: Array{Float64, 1}=[1.0]`: Risk-neutral opt: User specified quadrature weights on the interval [-ϵ,ϵ] for some ϵ (keyword arg)
- `verbose::Bool=false`: Whether to produce logging screen output (keyword arg)

# Returns
- `prob`: Joqbox Ipopt.IpoptProblem
- `params`: Juqbox objparams
- `wa`: Juqbox Working_Arrays
"""
function setup_juqbox_environment(;
        Tgate::Real,
        D1::Integer,
        pulseamplitudemax::Real,
        utarget::Matrix{ComplexF64},
        qubitfreq::Real,
        qubitanharmonicity::Real,
        Pmin::Integer,
        Nquditlevel::Integer=2,
        Nguardlevel::Integer=0,
        maxIter::Int64=100,
        lbfgsMax::Int64=10,
        ipTol::Float64=1e-5,
        acceptTol::Float64=1e-5,
        acceptIter::Int64=15,
        nodes::Array{Float64, 1}=[0.0],
        weights::Array{Float64, 1}=[1.0],
        verbose::Bool=false)
    # any change in `Nctrl` and `Nfreq` require modifying `get_juqbox_simulation_parameters` and `get_hamiltonians_control`
    Nctrl = 1  # Number of control channels
    Nfreq = 1  # Number of frequency components per control channel
    nCoeff = 2 * Nctrl * Nfreq * D1;

    if verbose
        println("*** Settings ***")
        println("System Hamiltonian coefficients: (freq, anharmonicity) =  ", qubitfreq, qubitanharmonicity)
        println("Total number of system states, Nquditlevel = ", Nquditlevel, " Total number of guard states, Nguardlevel = ", Nguardlevel)
        println("Using B-spline basis functions with carrier wave, # freq = ", Nfreq)
        println("Number of coefficients per spline = ", D1, " Total number of parameters = ", nCoeff)
        println("Max parameter amplitudes: pulseamplitudemax = ", pulseamplitudemax)
    end

    params = get_juqbox_simulation_parameters(
        Tgate=Tgate,
        pulseamplitudemax=pulseamplitudemax,
        utarget=utarget,
        qubitfreq=qubitfreq,
        qubitanharmonicity=qubitanharmonicity,
        Pmin=Pmin,
        Nquditlevel=Nquditlevel,
        Nguardlevel=Nguardlevel,
        Nctrl=Nctrl,
        Nfreq=Nfreq,
        verbose=verbose);

    if verbose
        println("Tikhonov coefficients: tik0 = ", params.tik0)
    end

    # min and max coefficient values
    minCoeff, maxCoeff = Juqbox.assign_thresholds(params, D1, [pulseamplitudemax]);
    # Allocate all working arrays
    wa = Juqbox.Working_Arrays(params, nCoeff);

    prob = Juqbox.setup_ipopt_problem(
        params, wa, nCoeff, minCoeff, maxCoeff,
        maxIter=maxIter,
        lbfgsMax=lbfgsMax,
        startFromScratch=true,
        ipTol=ipTol,
        acceptTol=acceptTol,
        acceptIter=acceptIter,
        nodes=nodes,
        weights=weights);

    return prob, params, wa
end;


"""
    get_juqbox_simulation_parameters(;<keyword arguments>)

Get the simulation parameters object for Juqbox

# Arguments
- `Tgate`: Duration of gate in ns (keyword arg)
- `pulseamplitudemax`: Maximum pulse amplitudes allowed for p(t) and q(t) (keyword arg)
- `utarget::Matrix{Number}`: Target Unitary in the lab frame (keyword arg)
- `qubitfreq::Real`: qubit regular frequency in GHz (keyword arg)
- `qubitanharmonicity::Real` qubit regular frequency anharmonicity in GHz (keyword arg)
- `Pmin::Real` Number of time steps per shortest period or sample rate assuming a slowly varying Hamiltonian (keyword arg)
- `Nquditlevel::Integer=2`: Number of essential energy levels (keyword arg)
- `Nguardlevel::Integer=0`: Number of guard energy levels (keyword arg)
- `Nctrl::Integer=1`: Number of control channels (keyword arg)
- `Nfreq::Integer=1`: Number of frequency components per control channel (keyword arg)
- `verbose::Bool=false`: Whether to produce logging screen output (keyword arg)
"""
function get_juqbox_simulation_parameters(;
        Tgate::Real,
        pulseamplitudemax::Real,
        utarget::Matrix{ComplexF64},
        qubitfreq::Real,
        qubitanharmonicity::Real,
        Pmin::Integer,
        Nquditlevel::Integer=2,
        Nguardlevel::Integer=0,
        Nctrl::Integer=1,
        Nfreq::Integer=1,
        verbose::Bool=false)
    # Carrier wave (angular) frequencies of size Cfreq[Nctrl, Nfreq]
    om = zeros(Nctrl, Nfreq);

    # Rotational (regular) frequencies for each control Hamiltonian; size Rfreq[Nctrl]
    rot_freq = [qubitfreq];

    Ntot = Nquditlevel + Nguardlevel
    H0 = get_hamiltonian_drift(qubitanharmonicity, Ntot);
    Hsym_ops, Hanti_ops = get_hamiltonians_control(Ntot);
    nsteps = calculate_timestep(
        Tgate, H0, Hsym_ops, Hanti_ops, [pulseamplitudemax], Pmin);
    U0 = get_unitary_initial(Nquditlevel, Ntot)

    # Get target unitary in the rotating frame
    omega1 = Juqbox.setup_rotmatrices([Nquditlevel], [Nguardlevel], rot_freq);
    rot1 = Diagonal(exp.(im * omega1 * Tgate));
    vtarget = rot1 * utarget;

    if verbose
        println("Carrier frequencies [GHz]: ", om[:,:]./(2*pi))
        println("Rotational frequencies [GHz]: ", rot_freq[:])
        println("Drift Hamiltonian: ", H0);
        println("Gate duration = ", Tgate, " # time steps per min-period, P = ", Pmin, " # time steps: ", nsteps);
        println("Target Unitary = ", utarget)
    end

    # setup the Juqbox simulation parameters
    params = Juqbox.objparams(
            [Nquditlevel],
            [Nguardlevel],
            Tgate,
            nsteps,
            Uinit=U0,
            Utarget=vtarget,
            Cfreq=om,
            Rfreq=rot_freq,
            Hconst=H0,
            Hsym_ops=Hsym_ops,
            Hanti_ops=Hanti_ops);
    return params
end;


"""
    get_hamiltonian_drift(qubitanharmonicity, Ntot)
"""
function get_hamiltonian_drift(qubitanharmonicity::Real, Ntot::Integer)
    # get drift Hamiltonian in the rotating frame
    number = Diagonal(collect(0:Ntot-1));
    H0 = -0.5*(2*pi)* qubitanharmonicity * (number*number - number);
    H0 = Array(H0)
    return H0
end;


"""
    get_hamiltonians_control(Ntot)
"""
function get_hamiltonians_control(Ntot::Integer)
    # lowering matrix
    amat = Bidiagonal(zeros(Ntot),sqrt.(collect(1:Ntot-1)),:U); # standard lowering operator matrix
    # raising matrix
    adag = transpose(amat); # raising operator matrix

    # dense matrices
    Hsym_ops=[Array(amat + adag)];
    Hanti_ops=[Array(amat - adag)];
    return Hsym_ops, Hanti_ops
end;


"""
    get_unitary_initial(Nquditlevel, Ntot)

Get the matrix holding the initial conditions for the solution matrix of size Uinit
"""
function get_unitary_initial(Nquditlevel::Integer, Ntot::Integer)
    Ident = Matrix{Float64}(I, Ntot, Ntot);
    U0 = Ident[1:Ntot,1:Nquditlevel];
    return U0
end;
