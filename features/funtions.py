from deepdiff import DeepDiff
from os.path import join


def read_data_from_file(context, file):
    file = join(context.data_home, file)
    with open(file, "r") as f:
        data = f.read()
    return data


def dict_diff_with_exclusions(context, d1, d2, exclude_file):
    ep = read_data_from_file(context, exclude_file).splitlines()
    return DeepDiff(d1, d2, exclude_paths=ep)


