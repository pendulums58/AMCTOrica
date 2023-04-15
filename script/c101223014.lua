--멜로디 나이트
--Scripted by Cyan
function c101223014.initial_effect(c)
	--페어링 소환
	cyan.AddPairingProcedure(c,c101223014.pfilter,c101223014.mfilter,1,1)
	c:EnableReviveLimit()
end
function c101223014.pfilter(c)
	return c:GetAttack()>=2000
end
function c101223014.mfilter(c,pair)
	return c:GetAttack()<pair:GetAttack()
end