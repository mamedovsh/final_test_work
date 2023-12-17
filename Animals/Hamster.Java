package Animals;

import java.util.List;

public class Hamster extends Pets {
    public Hamster(String name, List<String> commands) {
        super(name, commands);
    }

    @Override
    public String toString() {
        String commandsStr = Mapper.mapListToStr(this.getCommands());
        return "Pet. Hamster. Name: " + this.getName() + ". Commands: " + commandsStr;
    }
}