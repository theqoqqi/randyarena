function table.filterArray(t, filterFunc)
	return table.filter(t, filterFunc, true);
end

function table.filter(t, filterFunc, isArray)
	local out = {};
	for k, v in pairs(t) do
		if filterFunc(v, k, t) then
			if isArray then
				table.insert(out, v);
			else
				out[k] = v;
			end
		end
	end
	return out;
end

function table.exceptArray(t, exceptList)
	return table.except(t, exceptList, true);
end

function table.except(t, exceptList, isArray)
	return table.filter(t, function(v)
		return not table.contains(exceptList, v);
	end, isArray);
end

function table.map(t, mappingFunc)
	local out = {};
	for k, v in pairs(t) do
		out[k] = mappingFunc(v, k, t);
	end
	return out;
end

function table.isEmpty(t)
	return next(t) == nil;
end

function table.count(t)
	local count = 0;
	for k,v in pairs(t) do
		count = count + 1;
	end
	return count;
end

function table.insertAll(t, t2)
	for _, v in pairs(t2) do
		table.insert(t, v);
	end
end

function table.contains(tab, val)
	return table.indexOf(tab, val) ~= -1;
end

function table.containsAll(tab, values)
	for index, value in pairs(values) do
		if not table.contains(tab, value) then
			return false;
		end
	end
	return true;
end

function table.indexOf(tab, val)
	for index, value in pairs(tab) do
		if value == val then
			return index;
		end
	end
	return -1;
end

function table.removeValue(tab, val)
	tab[table.indexOf(tab, val)] = nil;
end

function table.insertIfAbsent(tab, val)
	if not table.contains(tab, val) then
		table.insert(tab, val);
	end
end

function table.copy(tab)
	local copy = {};
	for key, value in pairs(tab) do
		copy[key] = value;
	end
	return copy;
end

function table.deepcopy(orig)
	local orig_type = type(orig);
	local copy;
	if orig_type == 'table' then
		copy = {};
		for orig_key, orig_value in next, orig, nil do
			copy[table.deepcopy(orig_key)] = table.deepcopy(orig_value);
		end
		setmetatable(copy, table.deepcopy(getmetatable(orig)));
	else -- number, string, boolean, etc
		copy = orig;
	end
	return copy;
end

function table.keys(tab)
	local keys = {};
	for key, value in pairs(tab) do
		table.insert(keys, key);
	end
	return keys;
end

function table.any(t, predicate)
	for k, v in pairs(t) do
		if predicate(v, k, t) then
			return true;
		end
	end
	return false;
end

function table.all(t, predicate)
	for k, v in pairs(t) do
		if not predicate(v, k, t) then
			return false;
		end
	end
	return true;
end

function table.reduce(t, fn)
	local acc = 0;
	for k, v in ipairs(t) do
		acc = fn(acc, v);
	end
	return acc;
end

function string.split(inputstr, sep)
	if sep == nil then
		sep = "%s";
	end
	local t = {};
	local i = 1;
	for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
		t[i] = str;
		i = i + 1;
	end
	return t;
end

function string.starts(String, Start)
	return string.sub(String, 1, string.len(Start)) == Start;
end