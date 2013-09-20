from twistedsnmp import AgentProxy
from twisted.python import failure
from twisted.internet import reactor
import time

class Bogus(object): pass

def printResults(results):
    import pprint
    pprint.pprint(results)
    return results

def close(results, proxy):
    print "close"
    proxy.close()
    print "closed"

def shutdown(result):
    print "Shutdown"
    reactor.callLater(0.1, reactor.stop)

def main():
    oids = ['.1.3.6.1.2.1.1.5.0',
                '.1.3.6.1.2.1.1.1.0']
    oids2 = ['.1.3.6.1.2.1.1.1.0',
            '.1.3.6.1.2.1.1.2.0',
                 '.1.3.6.1.2.1.1.3.0',
            '.1.3.6.1.2.1.1.4.0',
    ]
    proxy = AgentProxy(ip='127.0.0.1',
                              port=161,
                       community='public',
                       snmpVersion = 1,
                                      protocol = Bogus(),
                       allowCache = False,
                       cmdLineArgs=[])

#    import pdb;pdb.set_trace()
    proxy.open()
    d = proxy.get(oids, 1.0, 3)
    d.addBoth(printResults)
    d.addCallback(close, proxy)
    d.addBoth(shutdown)
    reactor.run()
    print "end reactor"

if __name__ == '__main__':
    main()





