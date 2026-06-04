package com.healyn.appointments.repository;

import com.healyn.appointments.domain.Appointment;
import com.healyn.appointments.domain.AppointmentStatus;
import org.springframework.data.domain.Limit;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.time.Instant;
import java.util.Collection;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

public interface AppointmentRepository extends JpaRepository<Appointment, UUID> {

    Optional<Appointment> findByIdAndDeletedAtIsNull(UUID id);

    @Query("""
            select a
            from Appointment a
            where a.physiotherapistId = :physioId
              and a.deletedAt is null
              and a.scheduledAt >= :from
              and a.scheduledAt < :to
            """)
    List<Appointment> findByPhysioAndScheduledBetween(
            @Param("physioId") UUID physioId,
            @Param("from") Instant from,
            @Param("to") Instant to);

    // Optional filters are guarded by boolean flags rather than `:param is null` checks:
    // Postgres cannot infer the type of a bind parameter that appears only in a standalone
    // `is null` test (SQLSTATE 42P18), so each filter param is referenced solely in a typed
    // context (an IN list or a comparison) and toggled by its companion flag.
    @Query("""
            select a
            from Appointment a
            where a.deletedAt is null
              and (:filterPatients = false or a.patientId in :patientIds)
              and (:filterStatuses = false or a.status in :statuses)
              and (:filterFrom = false or a.scheduledAt >= :from)
              and (:filterTo = false or a.scheduledAt < :to)
            order by a.scheduledAt desc, a.id desc
            """)
    List<Appointment> listFirstPage(
            @Param("filterPatients") boolean filterPatients,
            @Param("patientIds") Collection<UUID> patientIds,
            @Param("filterStatuses") boolean filterStatuses,
            @Param("statuses") Collection<AppointmentStatus> statuses,
            @Param("filterFrom") boolean filterFrom,
            @Param("from") Instant from,
            @Param("filterTo") boolean filterTo,
            @Param("to") Instant to,
            Limit limit);

    @Query("""
            select a
            from Appointment a
            where a.deletedAt is null
              and (:filterPatients = false or a.patientId in :patientIds)
              and (:filterStatuses = false or a.status in :statuses)
              and (:filterFrom = false or a.scheduledAt >= :from)
              and (:filterTo = false or a.scheduledAt < :to)
              and (a.scheduledAt < :pivotTime
                   or (a.scheduledAt = :pivotTime and a.id < :pivotId))
            order by a.scheduledAt desc, a.id desc
            """)
    List<Appointment> listAfterCursor(
            @Param("filterPatients") boolean filterPatients,
            @Param("patientIds") Collection<UUID> patientIds,
            @Param("filterStatuses") boolean filterStatuses,
            @Param("statuses") Collection<AppointmentStatus> statuses,
            @Param("filterFrom") boolean filterFrom,
            @Param("from") Instant from,
            @Param("filterTo") boolean filterTo,
            @Param("to") Instant to,
            @Param("pivotTime") Instant pivotTime,
            @Param("pivotId") UUID pivotId,
            Limit limit);
}
