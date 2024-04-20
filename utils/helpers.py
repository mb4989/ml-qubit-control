import numpy as np

def get_ugate_fidelity(
    x, y,
    limit=None, # Measure fidelity for the first 'limit' elements
    config_template='config_template.json',
    pulse_data_path='/tmp/ugate.csv',
    output_objf_path='/tmp/ugate_fidelity.csv',
    cleanup=True,
    verbose=False):

    import os
    import csv
    import pandas as pd

    BASE_DIR = '../../'

    if limit != None:
        print('WARNING: Limiting fidelity computation to {} entries out of {}'.format(limit, x.shape[0]))

    if not os.path.isfile(BASE_DIR + config_template):
        print('ERROR: Cannot find file: {}'.format(config_template))
        return None

    with open(pulse_data_path, 'w') as f:
        writer = csv.writer(f)
        writer.writerows(pd.concat([pd.DataFrame(y[:limit]), pd.DataFrame(x[:limit])], axis=1).values)

    if verbose:
        print(os.system("cd " + BASE_DIR + " && julia check_UGate_pulse_objective_function.jl " +
            " --config_path " + config_template +
            " --pulse_data_path " + pulse_data_path +
            " --output_objf_path " + output_objf_path))
    else:
        print(os.system("cd " + BASE_DIR + " && julia check_UGate_pulse_objective_function.jl " +
            " --config_path " + config_template +
            " --pulse_data_path " + pulse_data_path +
            " --output_objf_path " + output_objf_path + " > /dev/null"))

    fidelity_data =  1 - pd.read_csv(output_objf_path, header=None).abs()

    if cleanup:
        os.system("rm -f " + pulse_data_path)
        os.system("rm -f " + output_objf_path)

    return fidelity_data.mean().values[0]

def get_xgate_fidelity(
    x, y,
    limit=None, # Measure fidelity for the first 'limit' elements
    config_template='config_template.json',
    pulse_data_path='/tmp/xgate.csv',
    output_objf_path='/tmp/xgate_fidelity.csv',
    cleanup=True,
    verbose=False):

    import os
    import csv
    import pandas as pd

    BASE_DIR = '../'

    if limit != None:
        print('WARNING: Limiting fidelity computation to {} entries out of {}'.format(limit, x.shape[0]))

    if not os.path.isfile(BASE_DIR + config_template):
        print('ERROR: Cannot find file: {}'.format(config_template))
        return None

    with open(pulse_data_path, 'w') as f:
        writer = csv.writer(f)
        if limit != None:
            writer.writerows(pd.concat([pd.DataFrame(y[:limit]),
                                        pd.DataFrame(x[:limit])], axis=1).values)
        else:
            writer.writerows(pd.concat([pd.DataFrame(y), pd.DataFrame(x)], axis=1).values)

    if verbose:
        print(os.system("cd " + BASE_DIR + " && julia check_RX_pulse_objective_function.jl " +
            " --config_path " + config_template +
            " --pulse_data_path " + pulse_data_path +
            " --output_objf_path " + output_objf_path))
    else:
        os.system("cd " + BASE_DIR + " && julia check_RX_pulse_objective_function.jl " +
            " --config_path " + config_template +
            " --pulse_data_path " + pulse_data_path +
            " --output_objf_path " + output_objf_path + " > /dev/null")

    fidelity_data =  1 - pd.read_csv(output_objf_path, header=None).abs()

    if cleanup:
        os.system("rm -f " + pulse_data_path)
        os.system("rm -f " + output_objf_path)

    return fidelity_data.mean().values[0]

def get_ygate_fidelity(
    x, y,
    limit=None, # Measure fidelity for the first 'limit' elements
    config_template='config_template.json',
    pulse_data_path='/tmp/ygate.csv',
    output_objf_path='/tmp/ygate_fidelity.csv',
    cleanup=True,
    verbose=False):

    import os
    import csv
    import pandas as pd

    BASE_DIR = '../'

    if limit != None:
        print('WARNING: Limiting fidelity computation to {} entries out of {}'.format(limit, x.shape[0]))

    if not os.path.isfile(BASE_DIR + config_template):
        print('ERROR: Cannot find file: {}'.format(config_template))
        return None

    with open(pulse_data_path, 'w') as f:
        writer = csv.writer(f)
        
        if limit != None:
            writer.writerows(pd.concat([pd.DataFrame(y[:limit]),
                                        pd.DataFrame(x[:limit])], axis=1).values)
        else:
            writer.writerows(pd.concat([pd.DataFrame(y), pd.DataFrame(x)], axis=1).values)

    if verbose:
        print(os.system("cd " + BASE_DIR + " && julia check_RY_pulse_objective_function.jl " +
            " --config_path " + config_template +
            " --pulse_data_path " + pulse_data_path +
            " --output_objf_path " + output_objf_path))
    else:
        os.system("cd " + BASE_DIR + " && julia check_RY_pulse_objective_function.jl " +
            " --config_path " + config_template +
            " --pulse_data_path " + pulse_data_path +
            " --output_objf_path " + output_objf_path + " > /dev/null")

    fidelity_data =  1 - pd.read_csv(output_objf_path, header=None).abs()

    if cleanup:
        os.system("rm -f " + pulse_data_path)
        os.system("rm -f " + output_objf_path)

    return fidelity_data.mean().values[0]

def plot_ugate_pulse(
    x, y,
    pulse_data_path='/tmp/pulse.csv',
    output_image_path='/tmp/image.png',
    cleanup=True,
    verbose=False):

    import os
    import csv
    import pandas as pd
    from IPython import display

    with open(pulse_data_path, 'w') as f:
        writer = csv.writer(f)
        writer.writerow(pd.concat([pd.DataFrame(y).T, pd.DataFrame(x).T], axis=1).values[0])

    if verbose:
        os.system("cd .. && julia visualization_ugate_pulse.jl --pulse_data_path " + pulse_data_path +
            "--output_image_path " + output_image_path)
    else:
        os.system("cd .. && julia visualization_ugate_pulse.jl --pulse_data_path " +  pulse_data_path +
            "--output_image_path " + output_image_path + " > /dev/null 2>&1")

    _ = display.Image(output_image_path)

    if cleanup:
        os.system("rm -f " + pulse_data_path)

    return _

def plot_bloch_sphere():
    # See visualization_bloch_sphere_single_qubit_pulse_python_display notebook
    print('TBD')
def get_basic_id(model):
    from tensorflow.keras.layers import Dense

    model_id = '{}'.format(model.input.shape[1])
    for layer in model.layers:
        if isinstance(layer, Dense):
            model_id += 'x{}'.format(layer.units)
    return model_id

def recover_original_structure(predictions):
    # Define the transformation for a single row
    def transform_row(row):
        return np.array([
            row[0], row[1], *([row[2]] * 6), row[3], row[4], *([0] * 10)
        ])
    
    # Apply the transformation to each row
    recovered = np.apply_along_axis(transform_row, 1, predictions)
    
    return recovered

