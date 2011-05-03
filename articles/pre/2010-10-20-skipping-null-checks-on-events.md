Yesterday I learned a neat C# trick that can be used to skip the traditional null check associated with defining, then firing events:

``` cs
public class MyClassWithAnEvent
{
    public event EventHandler MyEvent;

    protected void FireMyEvent()
    {
        if (MyEvent != null)
            MyEvent(this, EventArgs.Empty);
    }
}
```

By immediately assigning the event with an empty event handler, we can guarantee that the event is never null, thereby saving us a line of code whenever we call it:

``` cs
public class MyClassWithAnEvent
{
    public event EventHandler MyEvent = (o, e) => {};

    protected void FireMyEvent()
    {
        MyEvent(this, EventArgs.Empty);
    }
}
```
