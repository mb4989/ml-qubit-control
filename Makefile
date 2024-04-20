help:
	@echo "INFO: make <tab> to list targets"
.PHONY: help

jupyter-notebook:
	jupyter notebook
.PHONY: jupyter-notebook

jupyter-notebook-no-browser:
	jupyter notebook --no-browser --ip 0.0.0.0 --port=8080
	@echo "Use port: 8080"
.PHONY: jupyter-notebook-no-browser

jupyter-lab:
	jupyter-lab
.PHONY: jupyter-lab

jupyter-lab-no-browser:
	jupyter-lab --no-browser --ip 0.0.0.0 --port=8080
	@echo "Use port: 8080"
.PHONY: jupyter-lab-no-browser


generate_RX_pulse:
	@./example_shell_script_generate_RX_pulse.sh
.PHONY: generate_RX_pulse

generate_RX_pulse_1_guardlevel:
	@./example_shell_script_generate_RX_pulse_1_guardlevel.sh
.PHONY: generate_RX_pulse_1_guardlevel

check_RX_pulse_objective_function:
	@./example_shell_script_check_RX_pulse_objective_function.sh
.PHONY: check_RX_pulse_objective_function

check_RX_pulse_1_guardlevel_objective_function:
	@example_shell_script_check_RX_pulse_1_guardlevel_objective_function.sh
.PHONY: check_RX_pulse_1_guardlevel_objective_function

clean:
	make -C data_pulse clean
.PHONY: clean
