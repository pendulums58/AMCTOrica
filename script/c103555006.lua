--벚꽃 풀이
function c103555006.initial_effect(c)
	--융합 소환
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,103555006)
	e1:SetTarget(c103555006.target)
	e1:SetOperation(c103555006.activate)
	c:RegisterEffect(e1)
	--패발동
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e2:SetCondition(c103555006.handcon)
	c:RegisterEffect(e2)	
end
function c103555006.filter1(c)
	return c:IsFaceup() and c:IsCanBeFusionMaterial()
end
function c103555006.filter2(c,e)
	return not c:IsImmuneToEffect(e)
end
function c103555006.filter3(c,e)
	return c103555006.filter1(c) and not c:IsImmuneToEffect(e)
end
function c103555006.spfilter(c,e,tp,m,f,chkf)
	return c:IsType(TYPE_FUSION) and c:IsSetCard(0x65a) and (not f or f(c))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,nil,chkf)
end
function c103555006.fcheck(tp,sg,fc)
	if Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0 then
		return sg:FilterCount(Card.IsControler,nil,1-tp)<=1
	else
		return sg:FilterCount(Card.IsControler,nil,1-tp)<=0
	end
end
function c103555006.gcheck(tp)
	return	function(sg)
				return sg:FilterCount(Card.IsControler,nil,1-tp)<=1
			end
end
function c103555006.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=tp
		local mg1=Duel.GetFusionMaterial(tp)
		local mg2=Duel.GetMatchingGroup(c103555006.filter1,tp,0,LOCATION_MZONE,nil)
		if mg1:IsExists(c103555006.chkfilter,1,nil,tp) and mg2:GetCount()>0 then
			mg1:Merge(mg2)
			aux.FCheckAdditional=c103555006.fcheck
			aux.GCheckAdditional=c103555006.gcheck(tp)
		end
		local res=Duel.IsExistingMatchingCard(c103555006.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,nil,chkf)
		aux.FCheckAdditional=nil
		aux.GCheckAdditional=nil
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg3=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(c103555006.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg3,mf,chkf)
			end
		end
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c103555006.chkfilter(c,tp)
	return c:IsControler(tp)
end
function c103555006.activate(e,tp,eg,ep,ev,re,r,rp)
	local chkf=tp
	local mg1=Duel.GetFusionMaterial(tp):Filter(c103555006.filter2,nil,e)
	local mg2=Duel.GetMatchingGroup(c103555006.filter3,tp,0,LOCATION_MZONE,nil,e)
	if mg1:IsExists(c103555006.chkfilter,1,nil,tp) and mg2:GetCount()>0 then
		mg1:Merge(mg2)
		exmat=true
	end
	if exmat then
		aux.FCheckAdditional=c103555006.fcheck
		aux.GCheckAdditional=c103555006.gcheck(tp)
	end
	local sg1=Duel.GetMatchingGroup(c103555006.spfilter,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,nil,chkf)
	aux.FCheckAdditional=nil
	aux.GCheckAdditional=nil
	local mg3=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg3=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(c103555006.spfilter,tp,LOCATION_EXTRA,0,nil,e,tp,mg3,mf,chkf)
	end
	local sg=sg1:Clone()
	if sg2 then sg:Merge(sg2) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=sg:Select(tp,1,1,nil)
	local tc=tg:GetFirst()
	if not tc then return end
	if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
		if exmat then
			aux.FCheckAdditional=c103555006.fcheck
			aux.GCheckAdditional=c103555006.gcheck(tp)
		end
		local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
		aux.FCheckAdditional=nil
		aux.GCheckAdditional=nil
		tc:SetMaterial(mat1)
		local chkof=0
		if mat1:IsExists(Card.IsControler,1,nil,1-tp) then chkof=1 end
		Duel.SendtoGrave(mat1,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		if chkop==1 then
			local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_HAND,0,1,1,nil)
			if g:GetCount()>0 then Duel.SendtoGrave(g,REASON_EFFECT+REASON_DISCARD) end
		end
	else
		local mat2=Duel.SelectFusionMaterial(tp,tc,mg3,nil,chkf)
		local fop=ce:GetOperation()
		fop(ce,e,tp,tc,mat2)
	end
	tc:CompleteProcedure()
end
function c103555006.handcon(e)
	return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_ONFIELD,0)==0
end

