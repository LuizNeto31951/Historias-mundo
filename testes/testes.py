import unittest
from historias_testes import *
from likes_testes import *

if __name__ == "__main__":
    carregador = unittest.TestLoader()
    testes = unittest.TestSuite()

    testes.addTest(carregador.loadTestsFromTestCase(TesteHistorias))
    testes.addTest(carregador.loadTestsFromTestCase(TesteLikes))

    executor = unittest.TextTestRunner()
    executor.run(testes)