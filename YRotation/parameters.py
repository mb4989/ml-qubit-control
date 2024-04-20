PREFIX = './model/yrotation'

N_CSV_FILES = 1
JUQBOX_CONFIG='D1_10_Pmin_200' # 20 parameters, Pmin = 200
#JUQBOX_CONFIG='D1_10_Pmin_40' # 20 parameters, Pmin = 200
#GRANULARITY_CONFIG='128'
BASE_DIR="/local/ml4qcontrol/data_pulse/yrotation"

#NEURONS_PER_LAYER = [128, 128, 128, 128, 128, 128, 128, 128]
#MODEL_ID_PREFIX = 'largeMLP_'

#neurons_per_layer = [64, 64, 64]
#MODEL_ID_PREFIX = 'mediumMLP_'

#NEURONS_PER_LAYER = [16, 16, 16, 16, 16, 16, 16]
#NEURONS_PER_LAYER = [8, 12, 12, 16, 16, 16, 16]
#NEURONS_PER_LAYER = [16, 12, 8, 16, 12, 12, 12]
#NEURONS_PER_LAYER = [12, 8, 16, 12, 12, 8, 8]
NEURONS_PER_LAYER = [12, 8, 16, 12, 8]
MODEL_ID_PREFIX = 'smallMLP_'

#CSV_CONFIG='{}_Unit_{}'.format(JUQBOX_CONFIG, GRANULARITY_CONFIG)
CSV_CONFIG='{}'.format(JUQBOX_CONFIG)
CONFIG_TEMPLATE_JSON = 'config_template_{}.json'.format(JUQBOX_CONFIG)
