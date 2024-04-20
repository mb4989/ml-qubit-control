using ArgParse
using LinearAlgebra
using Random
using Juqbox
using JSON
using Dates
using DelimitedFiles

include("pulsegen/generate_unitary.jl");
include("pulsegen/juqbox_environment_setup.jl");
include("pulsegen/io.jl");
include("pulsegen/wrapper.jl");


function parse_commandline()
    s = ArgParseSettings()

    @add_arg_table s begin
        "--pulse_data_path"
            help = "input pulse data path"
            arg_type = String
            required = true
        "--config_path"
            help = "path of the configuration JSON file"
            arg_type = String
            required = true
        "--output_objf_path"
            help = "output objective function data path"
            arg_type = String
            required = true
    end
    return parse_args(s)
end


function main(pulse_data_path, config_path, output_objf_path)
    datas = readdlm(pulse_data_path, ',');
    n_runs = size(datas)[1];
    n_opt_parameters = size(datas)[2];

    parameter_dict = read_config(config_path);
    Nquditlevel = parameter_dict["Nquditlevel"];
    Nguardlevel = parameter_dict["Nguardlevel"];

    objf_list = []
    for j in 1:n_runs
        d = datas[j, :];
        pcof = d[1: n_opt_parameters - 1];
        angles = d[n_opt_parameters];

        utarget = get_RX_unitary(
            angles, Nquditlevel=Nquditlevel, Nguardlevel=Nguardlevel);
        juqbox_setup_dict = setup_juqbox_environment_from_config(
            utarget=utarget, config_path=config_path, verbose=false);
        params = juqbox_setup_dict["params"];
        wa = juqbox_setup_dict["wa"];
        objf, uhist, trfid = traceobjgrad(pcof, params, wa, true, false);
        append!(objf_list, objf)
    end;

    open(output_objf_path, "w") do io
        writedlm(io, objf_list, ',');
    end
end

if abspath(PROGRAM_FILE) == @__FILE__
    parsed_args = parse_commandline();
    pulse_data_path = parsed_args["pulse_data_path"];
    config_path = parsed_args["config_path"];
    output_objf_path = parsed_args["output_objf_path"];
    main(pulse_data_path, config_path, output_objf_path);
end;
