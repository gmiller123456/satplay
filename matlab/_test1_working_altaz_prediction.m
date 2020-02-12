constmath;

% testing
conv = pi / (180.0*3600.0);
dat  = 37;
eqeterms = 2;
timezone=0;
%Louisville
obsLat=38.2464000/rad;
obsLon=-85.7636/rad;
xp   =  1.0/rad;
yp   =  1.0/rad;
lod  =  0.0;
dut1 =  0.0;
ddpsi =0;
ddeps =0;

longstr1="1 25544U 98067A   20041.70177340  .00000229  00000-0  12293-4 0  9990";
longstr2="2 25544  51.6437 259.2514 0004765 250.6840 217.7791 15.49151695212255";

%18 Apr 2019 10:51:55	43°	NW
t.year=2020;
t.mon=1;
t.mday=10;
t.hour=12; %UT
t.min=0;
t.sec=0;
t.yday=40; %Day of year - 1

[startmfe, stopmfe, deltamin, satrec] = twoline2rv(longstr1, longstr2, 'c','e', 'a', 84);

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
