import pytest
from spacy import registry

PACKAGES = ["spacy", "spacy-legacy"]
FUNCTIONS = [
    ("architectures", "CharacterEmbed.v1"),
    ("architectures", "HashEmbedCNN.v1"),
    ("architectures", "MaxoutWindowEncoder.v1"),
    ("architectures", "MishWindowEncoder.v1"),
    ("architectures", "MultiHashEmbed.v1"),
    ("architectures", "Tagger.v1"),
    ("architectures", "TextCatBOW.v1"),
    ("architectures", "TextCatCNN.v1"),
    ("architectures", "TextCatEnsemble.v1"),
    ("architectures", "Tok2Vec.v1"),
    ("layers", "StaticVectors.v1"),
    ("loggers", "ConsoleLogger.v1"),
    ("loggers", "ConsoleLogger.v2"),
    ("loggers", "WandbLogger.v1"),
    ("scorers", "textcat_multilabel_scorer.v1"),
    ("scorers", "textcat_scorer.v1"),
]


@pytest.mark.parametrize("package", PACKAGES)
@pytest.mark.parametrize("reg_name,name", FUNCTIONS)
def test_registry(package, reg_name, name):
    func_name = f"{package}.{name}"
    assert registry.has(reg_name, func_name)
    assert registry.get(reg_name, func_name)
