from re import sub


if 'transformer' not in globals():
    from mage_ai.data_preparation.decorators import transformer
if 'test' not in globals():
    from mage_ai.data_preparation.decorators import test


@transformer
def transform(data, *args, **kwargs):
    """
    Template code for a transformer block.

    Add more parameters to this function if this block has multiple parent blocks.
    There should be one parameter for each output variable from each parent block.

    Args:
        data: The output from the upstream parent block
        args: The output from any additional upstream blocks (if applicable)

    Returns:
        Anything (e.g. data frame, dictionary, array, int, str, etc.)
    """

    # Select rows where 'passenger_count' and 'trip_distance' are non-zero:
    data = data[(data['passenger_count'] > 0) & (data['trip_distance'] > 0.0)]

    # New column by converting 'lpep_pickup_datetime' to a date:
    data['lpep_pickup_date'] = data['lpep_pickup_datetime'].dt.date

    # Unique VendorID values:
    print("Unique VendorID values: ")
    print(data['VendorID'].unique())

    # Converting column names to snake case:
    def snake_case(s):
        return '_'.join(
            sub('([A-Z][a-z]+)', r' \1',
            sub('([A-Z]+)', r' \1',
            s.replace('-', ' '))).split()).lower()


    new_columns = []
    for column in data.columns:
        new_column = snake_case(column)
        new_columns.append(new_column)

    print("Number of columns changed to snake case: ")
    print(len(data.columns) - sum(data.columns == new_columns))
    
    data.columns = new_columns


    return data


@test
def test_output(output, *args) -> None:
    """
    Template code for testing the output of the block.
    """
    assert output is not None, 'The output is undefined'
    assert 'vendor_id' in output.columns, "Dang, no 'vendor_id' in the dataset"
    assert any(output['passenger_count'] > 0), "Dang, 'passenger_count' is 0 somewhere"
    assert any(output['trip_distance'] > 0), "Dang, 'trip_distance' is 0 somewhere"