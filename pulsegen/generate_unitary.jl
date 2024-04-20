using LinearAlgebra


"""
    get_RX_unitary(gamma; <keyword arguments>)

Get RX(gamma) = exp(-i gamma * sigma_x / 2)
              = [[   cos(gamma/2), -i sin(gamma/2)],
                 [-i sin(gamma/2),    cos(gamma/2)]]

# Arguments
- `gamma::Real`: rotation angle
- `Nquditlevel::Integer=2`: Number of essential energy levels (keyword arg)
- `Nguardlevel::Integer=0`: Number of guard energy levels (keyword arg)
"""
function get_RX_unitary(
        gamma::Real;
        Nquditlevel::Integer=2,
        Nguardlevel::Integer=0)
    u = Matrix{ComplexF64}(I, Nquditlevel + Nguardlevel, Nquditlevel)
    u[1, 1] = cos(gamma / 2.)
    u[2, 2] = cos(gamma / 2.)
    u[1, 2] = -im * sin(gamma / 2.)
    u[2, 1] = -im * sin(gamma / 2.)
    return u
end;


"""
    get_RY_unitary(gamma; <keyword arguments>)

Get RY(gamma) = exp(-i gamma * sigma_y / 2)
              = [[cos(gamma/2), -sin(gamma/2)],
                 [sin(gamma/2),  cos(gamma/2)]]

# Arguments
- `gamma::Real`: rotation angle
- `Nquditlevel::Integer=2`: Number of essential energy levels (keyword arg)
- `Nguardlevel::Integer=0`: Number of guard energy levels (keyword arg)
"""
function get_RY_unitary(
        gamma::Real;
        Nquditlevel::Integer=2,
        Nguardlevel::Integer=0)
    u = Matrix{ComplexF64}(I, Nquditlevel + Nguardlevel, Nquditlevel)
    u[1, 1] = cos(gamma / 2.)
    u[2, 2] = cos(gamma / 2.)
    u[1, 2] = -sin(gamma / 2.)
    u[2, 1] = sin(gamma / 2.)
    return u
end;


"""
    get_RZ_unitary(gamma; <keyword arguments>)

Get RZ(gamma) = exp(-i gamma * sigma_z / 2)
              = [[e^{-i gamma/2}, 0             ],
                 [0,              e^{i gamma/2})]]

# Arguments
- `gamma::Real`: rotation angle
- `Nquditlevel::Integer=2`: Number of essential energy levels (keyword arg)
- `Nguardlevel::Integer=0`: Number of guard energy levels (keyword arg)
"""
function get_RZ_unitary(
        gamma::Real;
        Nquditlevel::Integer=2,
        Nguardlevel::Integer=0)
    u = Matrix{ComplexF64}(I, Nquditlevel + Nguardlevel, Nquditlevel)
    u[1, 1] = exp(-im * gamma / 2.)
    u[2, 2] = exp(im * gamma / 2.)
    u[1, 2] = 0.
    u[2, 1] = 0.
    return u
end;


"""
    get_ugate_unitary(theta, phi, lam; <keyword arguments>)

Get generic single-qubit rotation with 3 Eular angles
u = [[          cos(theta/2), -e^{i lam}       sin(theta/2)],
     [e^{i phi} sin(theta/2),  e^{i (phi+lam)} cos(theta/2)]]
reference: https://qiskit.org/documentation/stubs/qiskit.circuit.library.UGate.html

# Arguments
- `theta::Real`: Eular angle
- `phi::Real`: Eular angle
- `lam::Real`: Eular angle
- `Nquditlevel::Integer=2`: Number of essential energy levels (keyword arg)
- `Nguardlevel::Integer=0`: Number of guard energy levels (keyword arg)
"""
function get_ugate_unitary(
        theta::Real,
        phi::Real,
        lam::Real;
        Nquditlevel::Integer=2,
        Nguardlevel::Integer=0)
    u = Matrix{ComplexF64}(I, Nquditlevel + Nguardlevel, Nquditlevel)
    u[1, 1] = cos(theta / 2.)
    u[2, 2] = exp(im * (phi + lam)) * cos(theta / 2.)
    u[1, 2] = -exp(im * lam) * sin(theta / 2.)
    u[2, 1] = exp(im * phi) * sin(theta / 2.)
    return u
end;
