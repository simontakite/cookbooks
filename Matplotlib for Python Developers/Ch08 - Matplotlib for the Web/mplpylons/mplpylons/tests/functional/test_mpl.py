from mplpylons.tests import *

class TestMplController(TestController):

    def test_index(self):
        response = self.app.get(url(controller='mpl', action='index'))
        # Test response...
