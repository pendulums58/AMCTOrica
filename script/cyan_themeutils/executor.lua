--�����ڵ� ȿ���� ��ƿ

EFFECT_DOP_CONTROL=101299999

--��������� ���Ĺ�
--���(1-tp)�� �ڽ�(tp)�� �ʵ� ī�带 ������� �ϴ� ���, ���(1-tp)�� �ʵ嵵 ��� ���� + �ڽ��� ��


local dst=Duel.SelectTarget
function Duel.SelectTarget(selp,filter,tp,sloc,oloc,mn,mx,...)
	if Duel.IsPlayerAffectedByEffect(selp,EFFECT_DOP_CONTROL) 
	and	(bit.band(oloc,LOCATION_MZONE)==LOCATION_MZONE or bit.band(oloc,LOCATION_SZONE)==LOCATION_SZONE)then
		sloc=oloc
		selp=1-selp
	end
	return dst(selp,filter,tp,sloc,oloc,mn,mx,...)
end