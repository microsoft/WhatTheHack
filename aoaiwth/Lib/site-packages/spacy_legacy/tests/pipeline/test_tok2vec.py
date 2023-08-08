import pytest
from spacy.tests import util
from spacy_legacy.architectures.tok2vec import Tok2Vec_v1, MultiHashEmbed_v1, CharacterEmbed_v1
from spacy_legacy.architectures.tok2vec import MaxoutWindowEncoder_v1
from spacy_legacy.architectures.tok2vec import MishWindowEncoder_v1
from spacy_legacy.architectures.tok2vec import HashEmbedCNN_v1


@pytest.mark.parametrize(
    "width,embed_arch,embed_config,encode_arch,encode_config",
    # fmt: off
    [
        (8, MultiHashEmbed_v1, {"rows": [100, 100], "attrs": ["SHAPE", "LOWER"], "include_static_vectors": False}, MaxoutWindowEncoder_v1, {"window_size": 1, "maxout_pieces": 3, "depth": 2}),
        (8, MultiHashEmbed_v1, {"rows": [100, 20], "attrs": ["ORTH", "PREFIX"], "include_static_vectors": False}, MishWindowEncoder_v1, {"window_size": 1, "depth": 6}), 
        (8, CharacterEmbed_v1, {"rows": 100, "nM": 64, "nC": 8, "include_static_vectors": False}, MaxoutWindowEncoder_v1, {"window_size": 1, "maxout_pieces": 3, "depth": 3}),
        (8, CharacterEmbed_v1, {"rows": 100, "nM": 16, "nC": 2, "include_static_vectors": False}, MishWindowEncoder_v1, {"window_size": 1, "depth": 3}),
        (8, HashEmbedCNN_v1, {"depth":2,"embed_size":2,"window_size":4,"maxout_pieces":2,"subword_features":True,"pretrained_vectors":False}, MaxoutWindowEncoder_v1, {"window_size": 1, "maxout_pieces": 3, "depth": 2}),
        (8, HashEmbedCNN_v1, {"depth":2,"embed_size":2,"window_size":4,"maxout_pieces":2,"subword_features":True,"pretrained_vectors":False}, MishWindowEncoder_v1, {"window_size": 1, "depth": 3}),
    ],
    # fmt: on
)
def test_tok2vec(width, embed_arch, embed_config, encode_arch, encode_config):
    embed_config["width"] = width
    encode_config["width"] = width
    docs = util.get_batch(3)
    tok2vec = Tok2Vec_v1(embed_arch(**embed_config), encode_arch(**encode_config))
    tok2vec.initialize(docs)
    vectors, backprop = tok2vec.begin_update(docs)
    assert len(vectors) == len(docs)
    assert vectors[0].shape == (len(docs[0]), width)
    backprop(vectors)
