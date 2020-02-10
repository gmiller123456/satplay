constmath;

% testing
conv = pi / (180.0*3600.0);
dat  = 37;
eqeterms = 2;
timezone=0;
%Louisville
obsLat=38.2540/rad;
obsLon=-85.7590/rad;
xp   =  0.0;
yp   =  0.0;
lod  =  0.0;
dut1 =  0.0;
ddpsi =0;
ddeps =0;

longstr1 = '1 25544U 98067A   19107.92643309  .00001649  00000-0  33850-4 0  9997';
longstr2 = '2 25544  51.6431 300.7557 0001426 186.1547 315.1299 15.52563769165892';

%18 Apr 2019 10:51:55	43°	NW
t.year=2019;
t.mon=3;
t.mday=18;
t.hour=10+4;
t.min=51;
t.sec=55;
t.yday=107;

[startmfe, stopmfe, deltamin, satrec] = twoline2rv(longstr1, longstr2, 'c','e', 'a', 72);

dayfract=t.hour/24.0+t.min/60.0/24.0+t.sec/60.0/60.0/24.0;
diff=(t.yday+1+dayfract)-satrec.epochdays;
tsince=diff*24*60;

[satrec,rteme,vteme] = sgp4(satrec, tsince);

[ut1, tut1, jdut1, jdut1frac, utc, tai, tt, ttt, jdtt,jdttfrac, tdb, ttdb, jdtdb,jdtdbfrac, tcg, jdtcg,jdtcgfrac, tcb, jdtcb,jdtcbfrac ] ...
	  = convtime ( t.year, t.mon+1, t.mday, t.hour, t.min, t.sec, timezone, dut1, dat );

ateme = [0; 0; 0];
[recef1, vecef1, aecef1] = teme2ecef(rteme', vteme', ateme, ttt, jdut1+jdut1frac, lod, xp, yp, eqeterms);
[reci,veci,aeci] = ecef2eci  ( recef1,vecef1,aecef1,ttt,jdut1,lod,xp,yp,eqeterms,ddpsi,ddeps );

alt=.1524; %500 feet converted to km

[rho,az,el,drho,daz,del] = rv2razel ( reci,veci, obsLat,obsLon,alt,ttt,jdut1,lod,xp,yp,eqeterms,ddpsi,ddeps );

printf("\r\nAz:%f El:%f\r\n",az*rad,el*rad);
