PREFIX = '../model/xrotation'

N_CSV_FILES = 100
JUQBOX_CONFIG='D1_10_Pmin_200' # 20 parameters, Pmin = 200
BASE_DIR="../data_pulse/xrotation"

NEURONS_PER_LAYER = [4]
MODEL_ID_PREFIX = 'smallMLP_'

CSV_CONFIG='{}'.format(JUQBOX_CONFIG)
CONFIG_TEMPLATE_JSON = 'config_template_{}.json'.format(JUQBOX_CONFIG)
