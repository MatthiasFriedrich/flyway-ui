package com.googlecode.flyway.ui.example;

import com.googlecode.flyway.core.Flyway;
import com.googlecode.flyway.ui.FlywayProvider;

public class H2FlywayProvider implements FlywayProvider {

    @Override
    public Flyway provides() {
        Flyway flyway = new Flyway();
        flyway.setDataSource("jdbc:h2:file:target/foobar", "sa", null);
        flyway.setInitOnMigrate(true);
        return flyway;
    }
}
