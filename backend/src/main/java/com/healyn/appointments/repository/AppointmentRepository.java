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

    @Query("""
            select a
            from Appointment a
            where a.deletedAt is null
              and (:patientIds is null or a.patientId in :patientIds)
              and (:statuses is null or a.status in :statuses)
              and (:from is null or a.scheduledAt >= :from)
              and (:to is null or a.scheduledAt < :to)
            order by a.scheduledAt desc, a.id desc
            """)
    List<Appointment> listFirstPage(
            @Param("patientIds") Collection<UUID> patientIds,
            @Param("statuses") Collection<AppointmentStatus> statuses,
            @Param("from") Instant from,
            @Param("to") Instant to,
            Limit limit);

    @Query("""
            select a
            from Appointment a
            where a.deletedAt is null
              and (:patientIds is null or a.patientId in :patientIds)
              and (:statuses is null or a.status in :statuses)
              and (:from is null or a.scheduledAt >= :from)
              and (:to is null or a.scheduledAt < :to)
              and (a.scheduledAt < :pivotTime
                   or (a.scheduledAt = :pivotTime and a.id < :pivotId))
            order by a.scheduledAt desc, a.id desc
            """)
    List<Appointment> listAfterCursor(
            @Param("patientIds") Collection<UUID> patientIds,
            @Param("statuses") Collection<AppointmentStatus> statuses,
            @Param("from") Instant from,
            @Param("to") Instant to,
            @Param("pivotTime") Instant pivotTime,
            @Param("pivotId") UUID pivotId,
            Limit limit);
}
