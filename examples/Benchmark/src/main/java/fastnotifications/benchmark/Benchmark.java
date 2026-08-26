package fastnotifications.benchmark;

import fastnotifications.FastNotifications;
import org.openjdk.jmh.annotations.*;

import java.util.concurrent.TimeUnit;

@BenchmarkMode(Mode.Throughput)
@OutputTimeUnit(TimeUnit.MILLISECONDS)
@State(Scope.Benchmark)
@Warmup(iterations = 2, time = 1, timeUnit = TimeUnit.SECONDS)
@Measurement(iterations = 3, time = 1, timeUnit = TimeUnit.SECONDS)
@Fork(1)
public class Benchmark {

    @org.openjdk.jmh.annotations.Benchmark
    public Object benchmarkBuilderInstantiation() {
        return FastNotifications.builder()
            .tag("benchmark")
            .title("Title")
            .message("Message body")
            .urgency(FastNotifications.Urgency.NORMAL);
    }
}
