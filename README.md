### About
ShadowTable is an simple OOP table-wrapper implementation with .Changed event and pretty optimized with large-scale projects(not sure).

### API
```ruby
ShadowTable.New(Data : {any}, Settings : {any})
```
Creates new ShadowTable class.
```ruby
ShadowTable:SetProperty(PropertyName : string, NewValue : any)
```
Sets property(key) in ShadowTable class's data.
```ruby
ShadowTable:GetProperty(PropertyName : string) : any
```
Receives property(key) in ShadowTable class's data.
```ruby
ShadowTable:OnChangedProperty(PropertyName : string, Callback : () -> ())
```
Fires when there is a change in certain property of ShadowTable class's data.
```ruby
ShadowTable:OnAnyChangedProperty(Callback : () -> ())
```
Fires when there is a change in ANY property of ShadowTable class's data.
```ruby
ShadowTable:Remove()
```
Removes ShadowTable class and disconnects all .Changed signals.
