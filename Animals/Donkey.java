package Animals;
import java.util.List;
public class Donkey extends PackAnimals {
    public Donkey(String name, List<String> commands) {
        super(name, commands);
    }

    @Override
    public String toString() {
        String commandsStr = Mapper.mapListToStr(this.getCommands());
        return "Pack animals. Donkey. Name: " + this.getName() + ". Commands: " + commandsStr;
    }
}